# encoding: utf-8
module Padrino
  module Helpers
    module FormatHelpers
      # override default helper for readable time.
      def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs)/60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        case distance_in_minutes
        when 0..1
          return (distance_in_minutes==0) ? '刚刚' : '1 分钟前' unless include_seconds
          case distance_in_seconds
          when 0..5   then '5 秒钟前'
          when 6..10  then '10 秒钟前'
          when 11..20 then '20 秒钟前'
          when 21..40 then '半分钟前'
          when 41..59 then '1 分钟前'
          else             '1 分钟'
          end

        when 2..44        then "#{distance_in_minutes} 分钟前"
        when 45..1439     then "#{(distance_in_minutes.to_f / 60).round} 小时前"
        when 1440..2879   then "昨天"
        when 2880..4319   then "前天"
        else from_time.strftime(include_seconds ? "%Y-%m-%d %H:%M" : "%Y-%m-%d")
        end
      end
    end
  end
end