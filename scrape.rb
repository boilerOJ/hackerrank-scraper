#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'json'

contests = [ ]

HACKERRANK_URL = "https://www.hackerrank.com/rest/contests"
COOKIE = "not commiting this lol"

(1..9).each do |i|
  contests << "purdue-competitive-programming-week-#{i}"
end

(3..9).each do |i|
  contests << "purdue-advanced-competitive-programming-week-#{i}"
end

def get_json(url)
  page = open(url, 'Cookie' => COOKIE)
  json = JSON.parse(page.read)
  return json['models']
end

def get_leaderboard(contest_name, offset = 0, limit = 30)
  url = "#{HACKERRANK_URL}/#{contest_name}/leaderboard?offset=#{offset}&limit=#{limit}"
  get_json(url)
end

def get_challenges(contest_name, offset = 0, limit = 30)
  url = "#{HACKERRANK_URL}/#{contest_name}/challenges?offset=#{offset}&limit=#{limit}"
  get_json(url)
end

def get_challenge_leaderboard(contest_name, challenge_name, offset = 0, limit = 30)
  url = "#{HACKERRANK_URL}/#{contest_name}/challenges/#{challenge_name}/leaderboard?offset=#{offset}&limit=#{limit}"
  get_json(url)
end


scores = get_leaderboard 'purdue-advanced-competitive-programming-week-5'
puts scores
