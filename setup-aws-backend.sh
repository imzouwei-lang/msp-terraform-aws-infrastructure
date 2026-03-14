#!/bin/bash
# 一键配置 AWS 后端资源（只需运行一次）
set -e

ACCOUNT_ID="288761743095"
REGION="us-east-1"
BUCKET_NAME="terraform-state-${ACCOUNT_ID}"
TABLE_NAME="terraform-state-lock"
ROLE_NAME="GitHubActionsTerraformRole"
GITHUB_REPO="imzouwei-lang/msp-terraform-aws-infrastructure"

echo "=== 1. 创建 S3 后端存储 ==="
aws s3api create-bucket --bucket ${BUCKET_NAME} --region ${REGION} 2>/dev/null || echo "Bucket 已存在"
aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled
echo "✅ S3 Bucket: ${BUCKET_NAME}"

echo ""
echo "=== 2. 创建 DynamoDB 锁表 ==="
aws dynamodb create-table \
  --table-name ${TABLE_NAME} \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ${REGION} 2>/dev/null || echo "DynamoDB 表已存在"
echo "✅ DynamoDB Table: ${TABLE_NAME}"

echo ""
echo "=== 3. 创建 GitHub OIDC Provider ==="
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1 2>/dev/null || echo "OIDC Provider 已存在"
echo "✅ OIDC Provider 已配置"

echo ""
echo "=== 4. 创建 IAM Role ==="
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringLike": {
        "token.actions.githubusercontent.com:sub": "repo:${GITHUB_REPO}:*"
      },
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
      }
    }
  }]
}
EOF
)

aws iam create-role \
  --role-name ${ROLE_NAME} \
  --assume-role-policy-document "${TRUST_POLICY}" 2>/dev/null || echo "Role 已存在，更新信任策略..."
aws iam update-assume-role-policy --role-name ${ROLE_NAME} --policy-document "${TRUST_POLICY}"

# 附加管理员权限（生产环境建议使用最小权限）
aws iam attach-role-policy \
  --role-name ${ROLE_NAME} \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess 2>/dev/null || true

echo "✅ IAM Role: ${ROLE_NAME}"

echo ""
echo "=== 配置完成 ==="
echo "OIDC Provider: arn:aws:iam::${ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
echo "IAM Role: arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
echo "S3 Bucket: ${BUCKET_NAME}"
echo "DynamoDB Table: ${TABLE_NAME}"
echo ""
echo "下一步: 创建 GitHub 仓库并推送代码"
