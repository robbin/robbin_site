require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "BlogComments Model" do
  it 'can construct a new instance' do
    @blog_comments = BlogComments.new
    refute_nil @blog_comments
  end
end
