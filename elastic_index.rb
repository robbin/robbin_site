require File.expand_path("../config/boot.rb", __FILE__)

# use ruby standard logger because padrino logger has odd error in my production environment.
require 'logger'
class ::Logger; alias_method :write, :<<; end

if ENV['RACK_ENV'] == 'production'
  logger = ::Logger.new("log/production.log")
  logger.level = ::Logger::WARN
  use Rack::CommonLogger, logger
end

client = Elasticsearch::Client.new log: true
# client.index index: 'robbin_site', type: 'test', id: 1, body: {title: '范凯的博客文章', content: '博客内容更新'}

Blog.all.each do |blog|
  client.index index: 'robbin_site', type: 'article', id: blog.id, body: {title: blog.title, content: blog.content}
end
#
# client.search index: 'robbin_site', body: { query: { match: { _all: '减肥' } } }

# curl -XGET 'http://localhost:9200/robbin_site/article/_search?q=_all:减肥'

