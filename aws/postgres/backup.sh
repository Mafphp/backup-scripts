
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

BACKUP_FILE_NAME=

BUCKET_NAME=

REGION_NAME=

docker run --rm \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -v "$PWD:/backup" \
  amazon/aws-cli \
  s3 cp --region $REGION_NAME s3://$BUCKET_NAME/$BACKUP_FILE_NAME /backup/$BACKUP_FILE_NAME
