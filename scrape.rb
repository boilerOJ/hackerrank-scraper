#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'json'

contests = [ ]

HACKERRANK_URL = "https://www.hackerrank.com/rest/contests"
COOKIE = "not committing this lol"

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

def get_all_challenge_names(contest_list)
  challenge_list = {}
  contest_list.each do |contest|
    challenge_list[contest] = []
  end
  contest_list.each do |contest|
    challenges = get_challenges contest
    challenges.each do |ch|
      challenge_list[contest] << ch['slug']
    end
  end
  challenge_list
end

puts get_all_challenge_names(contests)

