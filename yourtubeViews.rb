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

if (ARGV[0])
  username = ARGV[0]
else
  puts "Please pass in a username to grab the videos from."
  puts "Ex. yourtubeViews.rb myUsername"
  exit
end

mech = Mechanize.new

# The user's Youtube videos page
page = mech.get("https://www.youtube.com/user/#{username}/videos")

# Grab the video titles
page.search(title_element).each do |title|
  titles.push(title.text)
end

# Grab the views for said titles
page.search(view_element).each do |info|
  info = info.text
  
  if (info.include?("views"))
    views.push(info)
  else
   upload_dates.push(info)
 end
end

# Headings
printf("%-50s|%-20s|%-15s|\n", "Video", "Views", "Upload Date")
88.times {print "-"}
puts 

# Print out the information
titles.each_with_index do |title,index|
  printf("%-50s|%-20s|%-15s|\n", title, views[index], upload_dates[index])
end 