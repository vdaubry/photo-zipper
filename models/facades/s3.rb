require 'aws-sdk'

module Facades
  class S3
    def initialize(bucket)
      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
      })

      s3 = AWS::S3.new 
      @bucket = s3.buckets[bucket]
    end

    def get(key, filename)
      unless ENV['TEST']
        obj = @bucket.objects[key]
        begin
          File.open("#{filename}", 'wb') do |file|
            obj.read do |chunk|
               file.write(chunk)
            end
          end
        rescue AWS::S3::Errors::NoSuchKey => e
          puts "Error : key doesn't exist"
        end
      end
    end

    def put(key, path_to_file)
      unless ENV['TEST']
        obj = @bucket.objects[key]
        obj.write(Pathname.new(path_to_file))
      end
    end
  end
end