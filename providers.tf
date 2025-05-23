terraform {
  required_providers {
    humanitec = {
      source  = "humanitec/humanitec"
      version = "~> 1.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "humanitec" {
  org_id = var.org_id
}