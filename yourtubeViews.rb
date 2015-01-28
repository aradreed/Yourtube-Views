#!/usr/bin/env ruby

# Yourtube Views v.001
# Arad Reed

## What's this thing do?
### Give it a Youtube username, and it'll check your views on your videos and tell you how many you have

# Requires mechanize gem. If it won't load, download it
require 'mechanize' rescue Gem::LoadError System 'gem install mechanize'

# Important variables
## HTML elements
title_element = "//a[@class='yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2']"
view_element  = "//div[@class='yt-lockup-meta']/ul/li"

username = ARGV[0] or abort 'Please pass in a username to grab the videos from.'

page = Mechanize.new.get("https://www.youtube.com/user/#{username}/videos")

# Grab the video titles
titles = page.search(title_element).map(&:text)

# Grab the views for said titles
views, upload_dates = *page.search(view_element).map(&:text).partition { |info| info.include? 'views' }

# Headings
printf "%-120s | %-20s | %-15s |\n", "Video", "Views", "Upload Date"
puts "-" * 163

# Print out the information
titles.each_with_index do |title, index|
  printf "%-120s | %-20s | %-15s |\n", title, views[index], upload_dates[index]
end
