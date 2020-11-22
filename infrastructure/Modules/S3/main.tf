#***  S3 Resources *****


# ---- Create bucket  --------

resource "aws_s3_bucket" "bucketweb" {
  count  = var.ENABLE_WEBSITE ? 1 : 0
  bucket = var.BUCKET_NAME
  acl    = "public-read"
  policy = <<POLICY
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "AWS":"*"
         },
         "Action":"s3:GetObject",
         "Resource":[
           "arn:aws:s3:::${var.BUCKET_NAME}/*"
         ]
      }
   ]
}
  POLICY
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  count  = var.ENABLE_WEBSITE ? 1 : 0
  bucket = aws_s3_bucket.bucketweb[0].id
  key    = "index.html"
  acl    = "public-read"
  source = var.PATH_INDEX
}
