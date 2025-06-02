provider "aws" {
  alias  = "primary"
  region = var.pri_region
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region
}

resource "aws_dynamodb_table" "primary" {
  provider = aws.primary
  name     = var.table_name
  hash_key = "ItemId"
  billing_mode = "PAY_PER_REQUEST"
  stream_enabled = true

  attribute {
    name = "ItemId"
    type = "S"
  }

  replica {
    region_name = var.sec_region
  }
}

