terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 0.5.47"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
