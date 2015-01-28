#!/usr/bin/env ruby

# Yourtube Views v.001
# Arad Reed

## What's this thing do?
### Give it a Youtube username, and it'll check your views on your videos and tell you how many you have

# Requires mechanize gem. If it won't load, download it
begin
  gem 'mechanize'
rescue LoadError
  puts "Installing mechanize gem..."
  system('gem install mechanize')
  Gem.clear_paths
end 

require 'mechanize'

# Important variables
## HTML elements
title_element = "//a[@class='yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2']"
view_element = "//div[@class='yt-lockup-meta']/ul/li"

## Video information
titles = []
views = []
upload_dates = []

username = ARGV[0] or abort 'Please pass in a username to grab the videos'

mech = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}

# The user's Youtube videos page
begin
  page = mech.get("https://www.youtube.com/user/#{username}/videos")
rescue Mechanize::ResponseCodeError
  puts "The YouTube page didn't respond. Username may not exist."
  exit
end

# Grab the video titles
titles = page.search(title_element).map(&:text)

# Grab the views for said titles
views, upload_dates = *page.search(view_element).map(&:text).partition { |info| info.include? 'views' }

# Headings
printf("%-50s|%-15s|%-10s\n", "Video", "Views", "Upload Date")
78.times {print "-"}
puts 

# Print out the information
titles.each_with_index do |title,index|
  if (title.length > 40)
    title = "#{title[0, 40]} (...)" 
  end
  
  printf("%-50s|%-15s|%-10s\n", title, views[index], upload_dates[index])
end 