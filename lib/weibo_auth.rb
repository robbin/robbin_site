# encoding: utf-8
require 'timeout'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class WeiboAuth
  
  def authorize_url
    "https://api.weibo.com/oauth2/authorize?response_type=code&client_id=#{APP_CONFIG['weibo_api_key']}&redirect_uri=#{URI.escape APP_CONFIG['weibo_redirect_uri']}"    
  end

  def callback(code)
    @uid = Timeout::timeout(20) do
      @access_token = JSON.parse(RestClient.post('https://api.weibo.com/oauth2/access_token', 
                                                 :client_id => APP_CONFIG['weibo_api_key'], 
                                                 :client_secret => APP_CONFIG['weibo_api_secret'],
                                                 :grant_type => 'authorization_code',
                                                 :code => code,
                                                 :redirect_uri => APP_CONFIG['weibo_redirect_uri'])
                                )['access_token']
      JSON.parse(RestClient.get("https://api.weibo.com/2/account/get_uid.json?access_token=#{@access_token}"))['uid']
    end
    raise Error, "验证失败" unless @uid
  rescue Timeout::Error
    raise Error, "访问超时，请稍后重试"
  end

  def get_user_info
    user_info = Timeout::timeout(20) do
      JSON.parse(RestClient.get("https://api.weibo.com/2/users/show.json?uid=#{@uid}&access_token=#{@access_token}"))
    end
    unless user_info["name"]
      STDERR.puts "Weibo获取用户信息错误:" + user_info.inspect
      raise Error, "获取用户信息时发生错误，请稍后重试"
    end
    user_info
  rescue Timeout::Error
    raise Error, "访问超时，请稍后重试"
  end
end