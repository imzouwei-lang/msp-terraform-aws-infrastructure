# Terraform AWS Infrastructure

使用 GitHub Actions + Terraform + AWS OIDC 实现无密钥的基础设施即代码部署。

## 架构

- **监控服务器**: t3.medium - Grafana + Prometheus
- **Wiki服务器**: t3.medium - Wiki.js 知识库

## 前置条件

在使用之前，需要先在 AWS 中配置 OIDC 和后端存储：

```bash
# 1. 创建 GitHub OIDC Provider
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

# 2. 创建 S3 后端存储
aws s3api create-bucket --bucket terraform-state-288761743095 --region us-east-1
aws s3api put-bucket-versioning --bucket terraform-state-288761743095 \
  --versioning-configuration Status=Enabled

# 3. 创建 DynamoDB 锁表
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# 4. 创建 IAM Role (见下方信任策略)
```

## IAM 信任策略

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Federated": "arn:aws:iam::288761743095:oidc-provider/token.actions.githubusercontent.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringLike": {
        "token.actions.githubusercontent.com:sub": "repo:imzouwei-lang/msp-terraform-aws-infrastructure:*"
      },
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
      }
    }
  }]
}
```

## 使用方法

1. 创建分支修改 `terraform/` 下的文件
2. 提交 PR → 自动运行 `terraform plan`
3. 合并到 main → 审批后自动 `terraform apply`

## GitHub Environment 配置

Settings → Environments → 创建 `production`：
- Required reviewers: 添加审批者
- Deployment branches: 限制 main 分支
