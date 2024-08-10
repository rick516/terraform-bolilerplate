#!/bin/bash
set -e

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 関数定義
print_step() {
    echo -e "${GREEN}Step $1: $2${NC}"
}

print_warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
}

print_error() {
    echo -e "${RED}Error: $1${NC}"
}

# 環境変数の設定
export PROJECT_ID="your-project-id"
export REGION="us-central1"
export TERRAFORM_STATE_BUCKET="your-terraform-state-bucket"

# Step 1: 必要なツールのインストール
print_step 1 "Installing required tools"
if ! command -v gcloud &> /dev/null; then
    print_warning "gcloud CLI not found. Please install it manually."
    exit 1
fi

if ! command -v terraform &> /dev/null; then
    print_warning "Terraform not found. Installing..."
    wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
    unzip terraform_1.0.11_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.0.11_linux_amd64.zip
fi

# Step 2: GCPプロジェクトの設定
print_step 2 "Setting up GCP project"
gcloud config set project $PROJECT_ID
gcloud services enable compute.googleapis.com \
    cloudbuild.googleapis.com \
    cloudresourcemanager.googleapis.com \
    iam.googleapis.com \
    sqladmin.googleapis.com \
    run.googleapis.com

# Step 3: Terraformステート用のバケット作成
print_step 3 "Creating Terraform state bucket"
gsutil mb -p $PROJECT_ID -l $REGION gs://$TERRAFORM_STATE_BUCKET || true

# Step 4: Terraformの初期化
print_step 4 "Initializing Terraform"
cd terraform
terraform init -backend-config="bucket=$TERRAFORM_STATE_BUCKET"

# Step 5: Terraform計画の生成
print_step 5 "Creating Terraform plan"
terraform plan -var-file="environments/dev/terraform.tfvars" -out=tfplan

# Step 6: Terraform計画の適用
print_step 6 "Applying Terraform plan"
read -p "Do you want to apply the Terraform plan? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply tfplan
else
    print_warning "Terraform apply skipped."
fi

print_step 7 "Setup and apply process completed"