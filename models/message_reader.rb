class MessageReader

  def initialize(msg=nil)
    @msg = msg
  end

  def read
    puts "found SQS message : #{@msg}"
    keys = JSON.parse(@msg)
    downloader = Download.new
    downloader.start(keys)

    zipper = Zipper.new(downloader.tmpdir)
    zipper.upload_zip

    puts "done uploading zip : #{zipper.zipname}, sending done message"
    Facades::SQS.new(ENV["DONE_ZIP_QUEUE_NAME"]).send({:zipkey => zipper.zipname}.to_json)
    downloader.clean_tmp_dir
  end
end
