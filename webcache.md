# Web应用的缓存设计模式

## ORM缓存引言

从10年前的2003年开始，在Web应用领域，ORM(对象-关系映射)框架就开始逐渐普及，并且流行开来，其中最广为人知的就是Java的开源ORM框架Hibernate，后来Hibernate也成为了EJB3的实现框架；2005年以后，ORM开始普及到其他编程语言领域，其中最有名气的是Ruby on rails框架的ORM － ActiveRecord。如今各种开源框架的ORM，乃至ODM(对象-文档关系映射，用在访问NoSQLDB)层出不穷，功能都十分强大，也很普及。

然而围绕ORM的性能问题，也一直有很多批评的声音。其实ORM的架构对插入缓存技术是非常容易的，我做的很多项目和产品，但凡使用ORM，缓存都是标配，性能都非常好。而且我发现业界使用ORM的案例都忽视了缓存的运用，或者说没有意识到ORM缓存可以带来巨大的性能提升。

## ORM缓存应用案例

我们去年有一个老产品重写的项目，这个产品有超过10年历史了，数据库的数据量很大，多个表都是上千万条记录，最大的表记录达到了9000万条，Web访问的请求数每天有300万左右。

老产品采用了传统的解决性能问题的方案：Web层采用了动态页面静态化技术，超过一定时间的文章生成静态HTML文件；对数据库进行分库分表，按年拆表。动态页面静态化和分库分表是应对大访问量和大数据量的常规手段，本身也有效。但它的缺点也很多，比方说增加了代码复杂度和维护难度，跨库运算的困难等等，这个产品的代码维护历来非常困难，导致bug很多。

进行产品重写的时候，我们放弃了动态页面静态化，采用了纯动态网页；放弃了分库分表，直接操作千万级，乃至近亿条记录的大表进行SQL查询；也没有采取读写分离技术，全部查询都是在单台主数据库上进行；数据库访问全部使用ActiveRecord，进行了大量的ORM缓存。上线以后的效果非常好：单台MySQL数据库服务器CPU的IO Wait低于5%；用单台1U服务器2颗4核至强CPU已经可以轻松支持每天350万动态请求量；最重要的是，插入缓存并不需要代码增加多少复杂度，可维护性非常好。

总之，采用ORM缓存是Web应用提升性能一种有效的思路，这种思路和传统的提升性能的解决方案有很大的不同，但它在很多应用场景(包括高度动态化的SNS类型应用)非常有效，而且不会显著增加代码复杂度，所以这也是我自己一直偏爱的方式。因此我一直很想写篇文章，结合示例代码介绍ORM缓存的编程技巧。

今年春节前后，我开发自己的个人网站项目，有意识的大量使用了ORM缓存技巧。对一个没多少访问量的个人站点来说，有些过度设计了，但我也想借这个机会把常用的ORM缓存设计模式写成示例代码，提供给大家参考。我的个人网站源代码是开源的，托管在github上：[robbin_site](https://github.com/robbin/robbin_site)

## ORM缓存的基本理念

我在2007年的时候写过一篇文章，分析ORM缓存的理念：[ORM对象缓存探讨](http://robbinfan.com/blog/3/orm-cache) ，所以这篇文章不展开详谈了，总结来说，ORM缓存的基本理念是：

* 以减少数据库服务器磁盘IO为最终目的，而不是减少发送到数据库的SQL条数。实际上使用ORM，会显著增加SQL条数，有时候会成倍增加SQL。
* 数据库schema设计的取向是尽量设计 _细颗粒度_ 的表，表和表之间用外键关联，颗粒度越细，缓存对象的单位越小，缓存的应用场景越广泛
* 尽量避免多表关联查询，尽量拆成多个表单独的主键查询，尽量多制造 `n + 1` 条查询，不要害怕“臭名昭著”的 `n + 1` 问题，实际上 `n + 1` 才能有效利用ORM缓存

## 利用表关联实现透明的对象缓存

在设计数据库的schema的时候，设计多个细颗粒度的表，用外键关联起来。当通过ORM访问关联对象的时候，ORM框架会将关联对象的访问转化成用主键查询关联表，发送 `n + 1`条SQL。而基于主键的查询可以直接利用对象缓存。

我们自己开发了一个基于ActiveRecord封装的对象缓存框架：[second_level_cache](https://github.com/csdn-dev/second_level_cache) ，从这个ruby插件的名称就可以看出，实现借鉴了Hibernate的二级缓存实现。这个对象缓存的配置和使用，可以看我写的[ActiveRecord对象缓存配置](http://robbinfan.com/blog/33/activerecord-object-cache) 。

下面用一个实际例子来演示一下对象缓存起到的作用：访问我个人站点的首页。 这个页面的数据需要读取三张表：blogs表获取文章信息，blog_contents表获取文章内容，accounts表获取作者信息。三张表的model定义片段如下，完整代码请看[models](https://github.com/robbin/robbin_site/tree/master/models) ：

	class Account < ActiveRecord::Base
	  acts_as_cached
	  has_many :blogs
	end
	
	class Blog < ActiveRecord::Base
	  acts_as_cached
	  belongs_to :blog_content, :dependent => :destroy 
	  belongs_to :account, :counter_cache => true
	end
	
	class BlogContent < ActiveRecord::Base
	  acts_as_cached
	end

传统的做法是发送一条三表关联的查询语句，类似这样的：

	SELECT blogs.*, blog_contents.content, account.name 
		FROM blogs 
		LEFT JOIN blog_contents ON blogs.blog_content_id = blog_contents.id 
		LEFT JOIN accounts ON blogs.account_id = account.id

往往单条SQL语句就搞定了，但是复杂SQL的带来的表扫描范围可能比较大，造成的数据库服务器磁盘IO会高很多，数据库实际IO负载往往无法得到有效缓解。

我的做法如下，完整代码请看[home.rb](https://github.com/robbin/robbin_site/blob/master/app/controllers/home.rb) ：

	@blogs = Blog.order('id DESC').page(params[:page])
	
这是一条分页查询，实际发送的SQL如下：

	SELECT * FROM blogs ORDER BY id DESC LIMIT 20
	
转成了单表查询，磁盘IO会小很多。至于文章内容，则是通过`blog.content`的对象访问获得的，由于首页抓取20篇文章，所以实际上会多出来20条主键查询SQL访问blog_contents表。就像下面这样：

	DEBUG -  BlogContent Load (0.3ms)  SELECT `blog_contents`.* FROM `blog_contents` WHERE `blog_contents`.`id` = 29 LIMIT 1
	DEBUG -  BlogContent Load (0.2ms)  SELECT `blog_contents`.* FROM `blog_contents` WHERE `blog_contents`.`id` = 28 LIMIT 1
	DEBUG -  BlogContent Load (1.3ms)  SELECT `blog_contents`.* FROM `blog_contents` WHERE `blog_contents`.`id` = 27 LIMIT 1
	......
	DEBUG -  BlogContent Load (0.9ms)  SELECT `blog_contents`.* FROM `blog_contents` WHERE `blog_contents`.`id` = 10 LIMIT 1

但是主键查询SQL不会造成表的扫描，而且往往已经被数据库buffer缓存，所以基本不会发生数据库服务器的磁盘IO，因而总体的数据库IO负载会远远小于前者的多表联合查询。特别是当使用对象缓存之后，会缓存所有主键查询语句，这20条SQL语句往往并不会全部发生，特别是热点数据，缓存命中率很高：

	DEBUG -  Cache read: robbin/blog/29/1
	DEBUG -  Cache read: robbin/account/1/0
	DEBUG -  Cache read: robbin/blogcontent/29/0
	DEBUG -  Cache read: robbin/account/1/0
	DEBUG -  Cache read: robbin/blog/28/1
	......
	DEBUG -  Cache read: robbin/blogcontent/11/0
	DEBUG -  Cache read: robbin/account/1/0
	DEBUG -  Cache read: robbin/blog/10/1
	DEBUG -  Cache read: robbin/blogcontent/10/0
	DEBUG -  Cache read: robbin/account/1/0

拆分n+1条查询的方式，看起来似乎非常违反大家的直觉，但实际上这是真理，我实践经验证明：数据库服务器的瓶颈往往是磁盘IO，而不是SQL并发数量。因此 _拆分n+1条查询本质上是以增加n条SQL语句为代价，简化复杂SQL，换取数据库服务器磁盘IO的降低_  当然这样做以后，对于ORM来说，有额外的好处，就是可以高效的使用缓存了。

## 按照column拆表实现细粒度对象缓存

数据库的瓶颈往往在磁盘IO上，所以应该尽量避免对大表的扫描。传统的拆表是按照row去拆分，保持表的体积不会过大，但是缺点是造成应用代码复杂度很高；使用ORM缓存的办法，则是按照column进行拆表，原则一般是：

* 将大字段拆分出来，放在一个单独的表里面，表只有主键和大字段，外键放在主表当中
* 将不参与where条件和统计查询的字段拆分出来，放在独立的表中，外键放在主表当中

_按照column拆表本质上是一个去关系化的过程。主表只保留参与关系运算的字段，将非关系型的字段剥离到关联表当中，关联表仅允许主键查询，以Key-Value DB的方式来访问。因此这种缓存设计模式本质上是一种SQLDB和NoSQLDB的混合架构设计_

下面看一个实际的例子：文章的内容content字段是一个大字段，该字段不能放在blogs表中，否则会造成blogs表过大，表扫描造成较多的磁盘IO。我实际做法是创建blog_contents表，保存content字段，schema简化定义如下：

	CREATE TABLE `blogs` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `title` varchar(255) NOT NULL,
	  `blog_content_id` int(11) NOT NULL,
	  `content_updated_at` datetime DEFAULT NULL,
	  PRIMARY KEY (`id`),
	);
	
	CREATE TABLE `blog_contents` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `content` mediumtext NOT NULL,
	  PRIMARY KEY (`id`)
	);

blog_contents表只有content大字段，其外键保存到主表blogs的blog_content_id字段里面。

model定义和相关的封装如下：

	class Blog < ActiveRecord::Base
	  acts_as_cached
	  delegate :content, :to => :blog_content, :allow_nil => true
	  
	  def content=(value)
	    self.blog_content ||= BlogContent.new
	    self.blog_content.content = value
	    self.content_updated_at = Time.now
	  end
	end
	
	class BlogContent < ActiveRecord::Base
	  acts_as_cached
	  validates :content, :presence => true
	end    

在Blog类上定义了虚拟属性content，当访问`blog.content`的时候，实际上会发生一条主键查询的SQL语句，获取`blog_content.content`内容。由于BlogContent上面定义了对象缓存`acts_as_cached`，只要被访问过一次，content内容就会被缓存到memcached里面。

这种缓存技术实际会非常有效，因为： _只要缓存足够大，所有文章内容可以全部被加载到缓存当中，无论文章内容表有多么大，你都不需要再访问数据库了_  更进一步的是： _这张大表你永远都只需要通过主键进行访问，绝无可能出现表扫描的状况_  为何当数据量大到9000万条记录以后，我们的系统仍然能够保持良好的性能，秘密就在于此。

还有一点非常重要： _使用以上两种对象缓存的设计模式，你除了需要添加一条缓存声明语句acts_as_cached以外，不需要显式编写一行代码_  有效利用缓存的代价如此之低，何乐而不为呢？

以上两种缓存设计模式都不需要显式编写缓存代码，以下的缓存设计模式则需要编写少量的缓存代码，不过代码的增加量非常少。

## 写一致性缓存

写一致性缓存，叫做write-through cache，是一个CPU Cache借鉴过来的概念，意思是说，当数据库记录被修改以后，同时更新缓存，不必进行额外的缓存过期处理操作。但在应用系统中，我们需要一点技巧来实现写一致性缓存。来看一个例子：

我的网站文章原文是markdown格式的，当页面显示的时候，需要转换成html的页面，这个转换过程本身是非常消耗CPU的，我使用的是Github的markdown的库。Github为了提高性能，用C写了转换库，但如果是非常大的文章，仍然是一个耗时的过程，Ruby应用服务器的负载就会比较高。

我的解决办法是缓存markdown原文转换好的html页面的内容，这样当再次访问该页面的时候，就不必再次转换了，直接从缓存当中取出已经缓存好的页面内容即可，极大提升了系统性能。我的网站文章最终页的代码执行时间开销往往小于10ms，就是这个原因。代码如下：

	def md_content  # cached markdown format blog content
	  APP_CACHE.fetch(content_cache_key) { GitHub::Markdown.to_html(content, :gfm) }
	end

这里存在一个如何进行缓存过期的问题，当文章内容被修改以后，应该更新缓存内容，让老的缓存过期，否则就会出现数据不一致的现象。进行缓存过期处理是比较麻烦的，我们可以利用一个技巧来实现自动缓存过期：

	def content_cache_key
	  "#{CACHE_PREFIX}/blog_content/#{self.id}/#{content_updated_at.to_i}"
	end
	
当构造缓存对象的key的时候，我用文章内容被更新的时间来构造key值，这个文章内容更新时间用的是blogs表的content_updated_at字段，当文章被更新的时候，blogs表会进行update，更新该字段。因此每当文章内容被更新，缓存的页面内容的key就会改变，应用程序下次访问文章页面的时候，缓存就会失效，于是重新调用`GitHub::Markdown.to_html(content, :gfm)`生成新的页面内容。 而老的页面缓存内容再也不会被应用程序存取，根据memcached的LRU算法，当缓存填满之后，将被优先剔除。

除了文章内容缓存之外，文章的评论内容转换成html以后也使用了这种缓存设计模式。具体可以看相应的源代码：[blog_comment.rb](https://github.com/robbin/robbin_site/blob/master/models/blog_comment.rb)

## 片段缓存和过期处理

Web应用当中有大量的并非实时更新的数据，这些数据都可以使用缓存，避免每次存取的时候都进行数据库查询和运算。这种片段缓存的应用场景很多，例如：

* 展示网站的Tag分类统计(只要没有更新文章分类，或者发布新文章，缓存一直有效)
* 输出网站RSS(只要没有发新文章，缓存一直有效)
* 网站右侧栏(如果没有新的评论或者发布新文章，则在一段时间例如一天内基本不需要更新)

以上应用场景都可以使用缓存，代码示例：

	def self.cached_tag_cloud
	  APP_CACHE.fetch("#{CACHE_PREFIX}/blog_tags/tag_cloud") do
	    self.tag_counts.sort_by(&:count).reverse
	  end
	end
	
对全站文章的Tag云进行查询，对查询结果进行缓存	
	
	<% cache("#{CACHE_PREFIX}/layout/right", :expires_in => 1.day) do %>

	<div class="tag">
	  <% Blog.cached_tag_cloud.select {|t| t.count > 2}.each do |tag| %>
	  <%= link_to "#{tag.name}<span>#{tag.count}</span>".html_safe, url(:blog, :tag, :name => tag.name) %>
	  <% end %>
	</div>
	......
	<% end %>
	
对全站右侧栏页面进行缓存，过期时间是1天。

缓存的过期处理往往是比较麻烦的事情，但在ORM框架当中，我们可以利用model对象的回调，很容易实现缓存过期处理。我们的缓存都是和文章，以及评论相关的，所以可以直接注册Blog类和BlogComment类的回调接口，声明当对象被保存或者删除的时候调用删除方法：

	class Blog < ActiveRecord::Base
	  acts_as_cached
	  after_save :clean_cache
	  before_destroy :clean_cache
	  def clean_cache
	    APP_CACHE.delete("#{CACHE_PREFIX}/blog_tags/tag_cloud")   # clean tag_cloud
	    APP_CACHE.delete("#{CACHE_PREFIX}/rss/all")               # clean rss cache
	    APP_CACHE.delete("#{CACHE_PREFIX}/layout/right")          # clean layout right column cache in _right.erb
	  end
	end
	
	class BlogComment < ActiveRecord::Base
	  acts_as_cached
	  after_save :clean_cache
	  before_destroy :clean_cache
	  def clean_cache
	    APP_CACHE.delete("#{CACHE_PREFIX}/layout/right")     # clean layout right column cache in _right.erb
	  end
	end  

在Blog对象的`after_save`和`before_destroy`上注册`clean_cache`方法，当文章被修改或者删除的时候，删除以上缓存内容。总之，可以利用ORM对象的回调接口进行缓存过期处理，而不需要到处写缓存清理代码。

## 对象写入缓存

我们通常说到缓存，总是认为缓存是提升应用读取性能的，其实缓存也可以有效的提升应用的写入性能。我们看一个常见的应用场景：记录文章点击次数这个功能。

文章点击次数需要每次访问文章页面的时候，都要更新文章的点击次数字段view_count，然后文章必须实时显示文章的点击次数，因此常见的读缓存模式完全无效了。每次访问都必须更新数据库，当访问量很大以后数据库是吃不消的，因此我们必须同时做到两点：

* 每次文章页面被访问，都要实时更新文章的点击次数，并且显示出来
* 不能每次文章页面被访问，都更新数据库，否则数据库吃不消

对付这种应用场景，我们可以利用对象缓存的不一致，来实现对象写入缓存。原理就是每次页面展示的时候，只更新缓存中的对象，页面显示的时候优先读取缓存，但是不更新数据库，让缓存保持不一致，积累到n次，直接更新一次数据库，但绕过缓存过期操作。具体的做法可以参考[blog.rb](https://github.com/robbin/robbin_site/blob/master/models/blog.rb) ：

    # blog viewer hit counter
	def increment_view_count
	  increment(:view_count)        # add view_count += 1
	  write_second_level_cache      # update cache per hit, but do not touch db
	                                # update db per 10 hits
	  self.class.update_all({:view_count => view_count}, :id => id) if view_count % 10 == 0
	end

`increment(:view_count)`增加view_count计数，关键代码是第2行`write_second_level_cache`，更新view_count之后直接写入缓存，但不更新数据库。累计10次点击，再更新一次数据库相应的字段。另外还要注意，如果blog对象不是通过主键查询，而是通过查询语句构造的，要优先读取一次缓存，保证页面点击次数的显示一致性，因此 [_blog.erb](https://github.com/robbin/robbin_site/blob/master/app/views/blog/_blog.erb) 这个页面模版文件开头有这样一段代码：

	<% 
      # read view_count from model cache if model has been cached.
	  view_count = blog.view_count
	  if b = Blog.read_second_level_cache(blog.id)
	    view_count = b.view_count
	  end
	%>

采用对象写入缓存的设计模式，就可以非常容易的实现写入操作的缓存，在这个例子当中，我们仅仅增加了一行缓存写入代码，而这个时间开销大约是1ms，就可以实现文章实时点击计数功能，是不是非常简单和巧妙？实际上我们也可以使用这种设计模式实现很多数据库写入的缓存功能。

常用的ORM缓存设计模式就是以上的几种，本质上都是非常简单的编程技巧，代码的增加量和复杂度也非常低，只需要很少的代码就可以实现，但是在实际应用当中，特别是当数据量很庞大，访问量很高的时候，可以发挥惊人的效果。我们实际的系统当中，缓存命中次数:SQL查询语句，一般都是5:1左右，即每次向数据库查询一条SQL，都会在缓存当中命中5次，数据主要都是从缓存当中得到，而非来自于数据库了。

## 其他缓存的使用技巧

还有一些并非ORM特有的缓存设计模式，但是在Web应用当中也比较常见，简单提及一下：

### 用数据库来实现的缓存

在我这个网站当中，每篇文章都标记了若干tag，而tag关联关系都是保存到数据库里面的，如果每次显示文章，都需要额外查询关联表获取tag，显然会非常消耗数据库。在我使用的`acts-as-taggable-on`插件中，它在blogs表当中添加了一个`cached_tag_list`字段，保存了该文章标记的tag。当文章被修改的时候，会自动相应更新该字段，避免了每次显示文章的时候都需要去查询关联表的开销。

### HTTP客户端缓存

基于资源协议实现的HTTP客户端缓存也是一种非常有效的缓存设计模式，我在2009年写过一篇文章详细的讲解了：[基于资源的HTTP Cache的实现介绍](http://robbinfan.com/blog/13/http-cache-implement) ，所以这里就不再复述了。

### 用缓存实现计数器功能

这种设计模式有点类似于对象写入缓存，利用缓存写入的低开销来实现高性能计数器。举一个例子：用户登录为了避免遭遇密码暴力破解，我限定了每小时每IP只能尝试登录5次，如果超过5次，拒绝该IP再次尝试登录。代码实现很简单，如下：

	post :login, :map => '/login' do
	  login_tries = APP_CACHE.read("#{CACHE_PREFIX}/login_counter/#{request.ip}")
	  halt 403 if login_tries && login_tries.to_i > 5  # reject ip if login tries is over 5 times
	  @account = Account.new(params[:account])
	  if login_account = Account.authenticate(@account.email, @account.password)
	    session[:account_id] = login_account.id
	    redirect url(:index)
	  else
	    # retry 5 times per one hour
	    APP_CACHE.increment("#{CACHE_PREFIX}/login_counter/#{request.ip}", 1, :expires_in => 1.hour)
	    render 'home/login'
	  end
	end

等用户POST提交登录信息之后，先从缓存当中取该IP尝试登录次数，如果大于5次，直接拒绝掉；如果不足5次，而且登录失败，计数加1，显示再次尝试登录页面。
			