require 'dotenv'
require 'raven'
require_relative '../config/application'

path = File.expand_path('../models', File.dirname(__FILE__))
Dir[path+"/**/*.rb"].each {|file| require file}


###########################################################
#
# Configuration
#
###########################################################

Dotenv.load(
      File.expand_path("../../.#{APP_ENV}.env", __FILE__),
      File.expand_path("../../private-conf/.env",  __FILE__))


Raven.configure do |config|
  config.dsn = ENV['RAVEN_URL']
end


###########################################################
#
# Start downloading images in queue
#
###########################################################

puts "Start polling messages from queue"
Facades::SQS.new(ENV["TO_ZIP_QUEUE_NAME"]).poll do |msg|
  Raven.capture do
    MessageReader.new(msg).read
  end
end