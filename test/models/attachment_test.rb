require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Attachment Model" do
  it 'can construct a new instance' do
    @attachment = Attachment.new
    refute_nil @attachment
  end
end
