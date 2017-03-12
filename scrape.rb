#!/usr/bin/env ruby

require 'set'
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

def get_all_challenge_info(contest_list)
  challenge_list = {}
  contest_list.each do |contest|
    challenge_list[contest] = []
  end
  contest_list.each do |contest|
    challenges = get_challenges contest
    challenges.each do |challenge|
      challenge_list[contest] << {
        slug: challenge['slug'],
        name: challenge['name'],
        leaderboard: get_challenge_leaderboard(contest, challenge['slug'])
      }
    end
  end
  challenge_list
end

def get_all_challengers(contest_list)
  challengers = Set.new
  contest_list.each do |contest|
    leaderboard = get_leaderboard contest
    leaderboard.each do |user|
      challengers << user['hacker']
    end
  end
  return challengers.to_a
end

def generate_scores(contest_list)
  scoreboard = Hash.new()
  data = get_all_challenge_info contest_list
  users = get_all_challengers contest_list
  data.each do |contest_slug, contest|
    contest.each do |challenge|
      leaderboard = challenge[:leaderboard]
      leaderboard.each do |challenger|
        hacker = challenger['hacker']
        if !scoreboard.key?(hacker) then
          scoreboard[hacker] = {
            'completed' => []
          }
        end
        scoreboard[hacker]['completed'] << challenge[:slug]
      end
    end
  end

  scoreboard
end

def generate_score_numbers(contest_list)
  scoreboard = Hash.new()
  scores = generate_scores(contest_list)
  scores.each do |user, scores|
    scoreboard[user] = scores['completed'].length
  end
  scoreboard
end

scores = generate_score_numbers(contests)
print scores.sort_by {|user, count| count}
