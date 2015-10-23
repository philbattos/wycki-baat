# encoding: utf-8

class AwsStorage < CarrierWave::Uploader::Base

  storage :fog

end
