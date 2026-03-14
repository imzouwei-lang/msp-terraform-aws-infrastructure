# MSP Terraform AWS Infrastructure

使用 GitHub Actions + Terraform + AWS OIDC 实现无密钥的基础设施即代码部署。

## 架构

- **msp-02**: t3.medium EC2 实例，预装 Docker + Docker Compose

## 组件

| 组件 | 说明 |
|------|------|
| GitHub OIDC Provider | GitHub Actions 通过 OIDC 获取临时 AWS 凭证 |
| IAM Role | GitHubActionsTerraformRole |
| S3 Bucket | terraform-state-288761743095（状态存储） |
| DynamoDB Table | terraform-state-lock（状态锁定） |
| Region | us-east-1 |

## CI/CD 流程

```
修改 terraform/ 文件 → 创建 PR → 自动 Plan → 合并到 main → 等待审批 → 自动 Apply
```

1. 创建分支，修改 `terraform/` 下的文件
2. 提交 PR，GitHub Actions 自动运行 `terraform plan`，结果评论到 PR
3. Review 后合并 PR 到 main
4. 触发 `terraform apply`，需要审批者批准后才会执行

## 目录结构

```
.
├── .github/workflows/terraform-cicd.yml   # CI/CD 流水线
├── terraform/
│   ├── main.tf          # Provider + Backend 配置
│   ├── variables.tf     # 变量定义
│   ├── resources.tf     # EC2 + 安全组资源
│   └── outputs.tf       # 输出
├── setup-aws-backend.sh # AWS 后端一键配置脚本
└── README.md
```

## 前置配置

### 1. 运行后端配置脚本（只需一次）

```bash
chmod +x setup-aws-backend.sh
./setup-aws-backend.sh
```

### 2. 配置 GitHub Environment

Settings → Environments → 创建 `production`：
- Required reviewers: 添加审批者
- Deployment branches: 限制 main 分支

## 使用示例

```bash
# 创建分支
git checkout -b feature/update-instance

# 修改 Terraform 配置
vim terraform/resources.tf

# 提交并创建 PR
git add terraform/
git commit -m "Update EC2 configuration"
git push origin feature/update-instance
# 在 GitHub 上创建 PR，查看 Plan 结果，合并后等待审批
```

## 安全最佳实践

- ✅ 使用 OIDC 而非长期凭证
- ✅ S3 版本控制保护状态文件
- ✅ DynamoDB 锁防止并发修改
- ✅ 需要人工审批才能部署
- ✅ 所有变更通过 PR Review
