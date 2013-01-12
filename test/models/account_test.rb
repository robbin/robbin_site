require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Account Model" do
  it 'can construct a new instance' do
    account = build(:account)
    refute_nil account
  end
  it 'can pass attribute' do
    user = create(:account, email:"test@test.com")
    assert_equal("test@test.com", user.email)
  end
end
