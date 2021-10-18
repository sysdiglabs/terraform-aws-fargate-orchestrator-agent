terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
      version = ">= 0.4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "sysdig" {
  sysdig_secure_api_token = var.sysdig_access_key
}

