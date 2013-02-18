module Padrino
  module Cache
    module Helpers
      module Fragment
        include Padrino::Helpers::OutputHelpers

        ##
        # This helper is used anywhere in your application you would like to associate a fragment
        # to be cached. It can be used in within a route:
        #
        # @param [String] key
        #   cache key
        # @param [Hash] opts
        #   cache options, e.g :expires_in
        # @param [Proc]
        #   Execution result to store in the cache
        #
        # @example
        #   # Caching a fragment
        #   class MyTweets < Padrino::Application
        #     enable :caching          # turns on caching mechanism
        #
        #     controller '/tweets' do
        #       get :feed, :map => '/:username' do
        #         username = params[:username]
        #
        #         @feed = cache( "feed_for_#{username}", :expires_in => 3 ) do
        #           @tweets = Tweet.all( :username => username )
        #           render 'partials/feedcontent'
        #         end
        #
        #         # Below outputs @feed somewhere in its markup
        #         render 'feeds/show'
        #       end
        #     end
        #   end
        #
        # @api public
        def cache(key, opts = nil, &block)
          began_at = Time.now
          if value = APP_CACHE.read(key.to_s)
            logger.debug "GET Fragment", began_at, key.to_s if defined?(logger)
            concat_content(value)
          else
            value = capture_html(&block)
            APP_CACHE.write(key.to_s, value, opts)
            logger.debug "SET Fragment", began_at, key.to_s if defined?(logger)
            concat_content(value)
          end
        end
      end # Fragment
    end # Helpers
  end # Cache
end # Padrino
