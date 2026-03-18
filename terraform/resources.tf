# Create S3 storage buckets
resource "aws_s3_bucket" "msp_bucket_1" {
  bucket = "msp-storage-1-${var.environment}"

  tags = {
    Name = "msp-storage-1-${var.environment}"
  }
}

resource "aws_s3_bucket" "msp_bucket_2" {
  bucket = "msp-storage-2-${var.environment}"

  tags = {
    Name = "msp-storage-2-${var.environment}"
  }
}
