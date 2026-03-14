resource "aws_s3_bucket" "msp_bucket" {
  bucket = "msp-storage-${var.environment}"

  tags = {
    Name = "msp-storage-${var.environment}"
  }
}
