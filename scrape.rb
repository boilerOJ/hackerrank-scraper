#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

contests = [ ]

(1..9).each do |i|
  contests << "purdue-competitive-programming-week-#{i}"
end

(3..9).each do |i|
  contests << "purdue-advanced-competitive-programming-week-#{i}"
end

def get(i)
  url = "https://www.hackerrank.com/contests/#{i}/challenges"
  puts url
  page = Nokogiri::HTML(open(url))   
  puts page.text
end

get contests[0]
