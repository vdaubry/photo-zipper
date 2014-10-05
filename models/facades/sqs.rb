require 'aws-sdk'

module Facades
  class SQS

    attr_accessor :queue

    def initialize(queue)
      return if ENV["TEST"]
      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
      :region => "eu-west-1"
      })

      sqs = AWS::SQS.new 

      @queue = begin
                sqs.queues.named(queue)
              rescue AWS::SQS::Errors::NonExistentQueue => e
                sqs.queues.create(queue,
                  :visibility_timeout => 30*60,
                  :message_retention_period => 1209600)
              end
    end

    def send(message)
      return if ENV["TEST"]
      @queue.send_message("#{message}") unless message.nil?
    end

    def poll
      puts "Start polling queue : #{@queue.url}"
      @queue.poll do |received_message| 
        yield(received_message.body)
      end
    end
  end
end