require "tmpdir"
require "securerandom"
require 'fileutils'

class Download
  attr_accessor :tmpdir
  
  def initialize
    @tmpdir = "#{Dir.tmpdir}/#{SecureRandom.uuid}"
    FileUtils.mkdir @tmpdir
  end

  def clean_tmp_dir
     FileUtils.rmdir @tmpdir
  end

  def start(keys)
    puts "downloading #{keys.count} images in #{@tmpdir}"
    keys.each do |key|
      filename = key.split('/').last
      Facades::S3.new(ENV['SOURCE_S3_BUCKET']).get(key, "#{@tmpdir}/#{filename}")
    end
  end
end
