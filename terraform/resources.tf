# S3 存储桶
resource "aws_s3_bucket" "msp_storage" {
  bucket = "msp-storage-288761743095"

  tags = {
    Name = "msp-storage"
  }
}

resource "aws_s3_bucket_versioning" "msp_storage" {
  bucket = aws_s3_bucket.msp_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
