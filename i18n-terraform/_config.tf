terraform {
  required_version = "0.15.0"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "archive" {
}

provider "template" {
}

provider "null" {
}

locals {
  tags = merge(var.tags, tomap({
    "Layer" = "frontend-crm"
  }))
}

