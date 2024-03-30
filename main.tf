terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider aws {
  region = var.region
  //for devlopers if needed 
  access_key = "AKIAWUZ7YMDRMVDQCDND"
  secret_key = "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"


}


