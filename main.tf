terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "your-terraform-state-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# VPCモジュール
module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region
}

# Cloud SQLモジュール
module "cloud_sql" {
  source     = "./modules/cloud_sql"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
}

# Cloud Runモジュール（フロントエンド）
module "cloud_run_frontend" {
  source     = "./modules/cloud_run"
  project_id = var.project_id
  region     = var.region
  name       = "frontend"
  image      = var.frontend_image
}

# Cloud Runモジュール（バックエンド）
module "cloud_run_backend" {
  source     = "./modules/cloud_run"
  project_id = var.project_id
  region     = var.region
  name       = "backend"
  image      = var.backend_image
}

# Cloud Storageモジュール
module "cloud_storage" {
  source     = "./modules/cloud_storage"
  project_id = var.project_id
  region     = var.region
}

# Firebaseモジュール
module "firebase" {
  source     = "./modules/firebase"
  project_id = var.project_id
}

# Secret Managerモジュール
module "secret_manager" {
  source     = "./modules/secret_manager"
  project_id = var.project_id
}

# Vertex AIモジュール
module "vertex_ai" {
  source     = "./modules/vertex_ai"
  project_id = var.project_id
  region     = var.region
}

# Kafkaモジュール
module "kafka" {
  source     = "./modules/kafka"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
}