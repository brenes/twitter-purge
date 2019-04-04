#!/usr/bin/env ruby

require 'date'
require 'rubygems'
require 'twitter'

USERNAME            = ENV['USERNAME']
CONSUMER_KEY        = ENV['CONSUMER_KEY']
CONSUMER_SECRET     = ENV['CONSUMER_SECRET']
ACCESS_TOKEN        = ENV['ACCESS_TOKEN']
ACCESS_TOKEN_SECRET = ENV['ACCESS_TOKEN_SECRET']
DAYS_TO_KEEP        = ENV['DAYS_TO_KEEP'].to_i

# security measure so a bad heroku config doesn't remove all your tweets
unless ENV['DAYS_TO_KEEP'].empty?
  client = Twitter::REST::Client.new({
    :consumer_key        => CONSUMER_KEY,
    :consumer_secret     => CONSUMER_SECRET,
    :access_token        => ACCESS_TOKEN,
    :access_token_secret => ACCESS_TOKEN_SECRET
  })

  date_limit = (Date.today - DAYS_TO_KEEP).to_time
  client.user_timeline(USERNAME, :count => '150').each do |t|
    client.destroy_status(t.id) if t.created_at < date_limit;
  end
end
