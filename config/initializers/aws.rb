Aws.config.update({
  region: 'us-west-1',
  credentials: Aws::Credentials.new(ENV['AWS_S3_KEY'], ENV['AWS_S3_SECRET']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'])