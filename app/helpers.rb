# encoding: utf-8
require 'xmlrpc/client'

RobbinSite.helpers do
  include Padrino::Cache::Helpers::Fragment
  
  # authentication helpers
  def current_account
    return @current_account if @current_account
    return @current_account = Account.find_by_id(session[:account_id]) if session[:account_id]
    if request.cookies['user'] && (@current_account = Account.validate_cookie(request.cookies['user']))
      session[:account_id] = @current_account.id
      return @current_account
    end
  end
  
  def account_login?
    current_account ? true : false
  end
  
  def account_admin?
    current_account && current_account.admin? ? true : false
  end

  def account_commenter?
    current_account && current_account.commenter? ? true : false
  end
  
  # blog article url generator for SEO purpose
  def blog_url(blog, mime_type = :html)
    if blog.slug_url.blank?
      slug_url = url(:blog, :show, :id => blog.id)
    else
      slug_url = url(:blog, :show_url, :id => blog.id, :url => blog.slug_url)
    end
    slug_url << "." << mime_type.to_s if mime_type != :html
    slug_url
  end
  
  # generate commenter logo and link
  def commenter_logo(commenter)
    if commenter.provider && commenter.provider == 'weibo'
      link_to image_tag(commenter.profile_image_url, :alt => commenter.name), "http://weibo.com/#{commenter.profile_url}", :target => '_blank', :rel => 'nofollow'
    else
      link_to image_tag(commenter.logo.url, :alt => commenter.name), APP_CONFIG['site_url']
    end
  end
  
  def commenter_link(commenter)
    if commenter.provider && commenter.provider == 'weibo'
      link_to commenter.name, "http://weibo.com/#{commenter.profile_url}", :target => '_blank', :rel => 'nofollow'
    else
      link_to commenter.name, APP_CONFIG['site_url']
    end
  end  
  
  def blog_category_icon(blog)
    if blog.category == 'note'
      "<span class='note_icon' title='学习笔记'></span>".html_safe
    else
      "<span class='blog_icon' title='博客文章'></span>".html_safe
    end
  end
  
  # blog search ping for SEO purpose
  def ping_search_engine(blog)
    # http://www.google.cn/intl/zh-CN/help/blogsearch/pinging_API.html
    # http://www.baidu.com/search/blogsearch_help.html
    baidu = XMLRPC::Client.new2("http://ping.baidu.com/ping/RPC2")
    baidu.timeout = 5  # set timeout 5 seconds
    baidu.call("weblogUpdates.extendedPing",
               APP_CONFIG['site_title'],
               APP_CONFIG['site_url'],
               APP_CONFIG['site_url'] + '/' + blog_url(blog),
               APP_CONFIG['site_url'] + '/rss')

    google = XMLRPC::Client.new2("http://blogsearch.google.com/ping/RPC2")
    google.timeout = 5  # set timeout 5 seconds
    google.call("weblogUpdates.extendedPing",
                APP_CONFIG['site_title'],
                APP_CONFIG['site_url'],
                APP_CONFIG['site_url'] + '/' + blog_url(blog),
                APP_CONFIG['site_url'] + '/rss',
                blog.cached_tag_list.gsub(/,/, '|'))
  rescue Exception => e
    logger.error e
  end
end