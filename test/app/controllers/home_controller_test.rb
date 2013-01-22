require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "HomeController" do
  before do
    get '/'
  end

  it "should return hello world text" do
    assert_equal "Hello World", last_response.body
  end
end
