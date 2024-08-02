provider "linode" {
  # トークンは環境変数 LINODE_TOKEN で設定するか、
  # ここで直接指定します（セキュリティ上、環境変数を推奨）
  # token = "your_linode_api_token"
}

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    bucket = "terraform.turai.work"
    region = "ap-northeast-1"
    # profile = "terraform"
    key = "aws/ses-user/terraform.tfstate"
  }
}

