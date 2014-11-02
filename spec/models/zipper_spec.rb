require "spec_helper"
require "fileutils"

describe Zipper do
  describe "upload_zip" do
    before(:each) do
      @test_dir = "tmp/test"
      FileUtils.rm_rf @test_dir
      FileUtils.mkdir_p @test_dir
      2.times do |i|
        File.new("#{@test_dir}/foobar#{i}.jpg", "w+")
      end
      SecureRandom.stubs(:uuid).returns("foo")
    end

    it "zip all images" do
      zipper = Zipper.new(@test_dir)
      zipper.expects(:zip).with("#{@test_dir}/foo.zip", "#{@test_dir}/foobar0.jpg #{@test_dir}/foobar1.jpg")
      zipper.upload_zip
    end

    it "ignores zip files" do
      File.new("#{@test_dir}/foobar.zip", "w+")
      
      zipper = Zipper.new(@test_dir)
      zipper.expects(:zip).with("#{@test_dir}/foo.zip", "#{@test_dir}/foobar0.jpg #{@test_dir}/foobar1.jpg")
      zipper.upload_zip
    end

    it "uploads zip to S3" do
      zipper = Zipper.new(@test_dir)
      Facades::S3.any_instance.expects(:put).with("foo.zip", "#{@test_dir}/foo.zip")
      zipper.upload_zip
    end
  end
end