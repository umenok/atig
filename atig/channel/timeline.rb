#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

require 'atig/channel/channel'
module Atig
  module Channel
    class Timeline < Atig::Channel::Channel
      def initialize(context, gateway, db)
        super

        db.statuses.listen do|entry|
          case entry.source
          when :timeline, :me
            @channel.message entry
          end
        end

        db.followings.listen do|kind, users|
          @channel.send kind,users
        end
      end

      def channel_name; "#twitter" end
    end
  end
end