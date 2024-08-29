terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }

    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.3.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }

  required_version = ">= 1.3"
}