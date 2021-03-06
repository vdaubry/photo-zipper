require "securerandom"

class Zipper
  attr_accessor :dir
  attr_accessor :zipname

  def initialize(dir)
    @dir=dir
  end

  def upload_zip
    @zipname = "#{SecureRandom.uuid}.zip"
    files_to_zip = Dir.glob("#{@dir}/*").reject {|f| File.extname(f).include?(".zip")}
    puts "Zipping #{files_to_zip.count} images to #{@dir}/#{@zipname}"
    zip("#{@dir}/#{@zipname}", files_to_zip.join(" "))

    puts "Upload zip to S3"
    Facades::S3.new(ENV["DESTINATION_S3_BUCKET"]).put(@zipname, "#{@dir}/#{@zipname}")
  end

  def zip(zipname, files_to_zip)
    `zip -j #{zipname} #{files_to_zip}` unless ENV['TEST']
  end
end