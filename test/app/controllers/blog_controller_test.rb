require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "BlogController" do
  before do
    get '/'
  end

  it "should return hello world text" do
    refute_nil last_response.body
    # assert_equal "Hello World", last_response.body
  end
end
