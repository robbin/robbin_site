require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Blog Model" do
  it 'can construct a new instance' do
    @blog = Blog.new
    refute_nil @blog
  end
end
