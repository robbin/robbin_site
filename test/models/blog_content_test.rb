require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "BlogContent Model" do
  it 'can construct a new instance' do
    @blog_content = BlogContent.new
    refute_nil @blog_content
  end
end
