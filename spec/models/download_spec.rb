require "spec_helper"

describe Download do
  describe "start" do
    let(:keys) {["139/139789/139789702/1397897025_1135558.jpg", "139/139789/139789708/1397897084_1135571.jpg"]}

    it "downloads all files" do
      Facades::S3.any_instance.expects(:get).with("139/139789/139789702/1397897025_1135558.jpg", anything).once
      Facades::S3.any_instance.expects(:get).with("139/139789/139789708/1397897084_1135571.jpg", anything).once
      Download.new.start(keys)
    end

  end
end