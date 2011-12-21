# Paperclip.interpolates(:s3_eu_url) do |att, style|
#   "#{att.s3_protocol}://s3-eu-west-1.amazonaws.com/#{att.bucket}/#{att.path(style).gsub(%r{^/}, "")}"
# end

# require 'aws/s3'

# AWS::S3::DEFAULT_HOST.replace "s3-eu-west-1.amazonaws.com"
