terraform {
    backend "s3" {
        bucket = "carone1999"
        region = "us-east-1"
        key = "modules/terraformstate"
    }
}