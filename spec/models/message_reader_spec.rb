require "spec_helper"

describe MessageReader do
  let(:message) {["image/140/140809/140809922/1408099220_1898086.jpg","image/140/140809/140809922/1408099226_1901623.jpg"].to_json}
  
  describe "read" do
    it "downloads keys in message" do
      Download.any_instance.expects(:start).with(["image/140/140809/140809922/1408099220_1898086.jpg","image/140/140809/140809922/1408099226_1901623.jpg"])
      MessageReader.new(message).read
    end

    it "zips downloaded files" do
      Zipper.any_instance.expects(:upload_zip)
      MessageReader.new(message).read
    end

    it "cleans tmp dir" do
      Download.any_instance.expects(:clean_tmp_dir)
      MessageReader.new(message).read
    end

    it "sends done zip" do
      Zipper.any_instance.stubs(:zipname).returns("foobar.zip")
      Facades::SQS.any_instance.expects(:send).with({:zipkey => "foobar.zip"}.to_json).once
      MessageReader.new(message).read
    end
  end
end