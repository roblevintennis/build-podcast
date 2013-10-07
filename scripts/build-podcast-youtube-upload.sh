---
layout: nil
date: 2013-09-15 13:00:00
---
#!/bin/bash

# this script loops through all the posts, uploads video to youtube and
# adds them to a youtube playlist

# use this shell script with youtube-upload
# https://code.google.com/p/youtube-upload/

# make Jekyll render out this shell script by looping it through all posts

{% for post in site.posts reversed %}

# download the original video
videoFile={{ post.enclosure }}
wget $videoFile

# upload the video to youtube with title, tags, description
youtube-upload --email=sayanee@gmail.com --password=xxxxxxxx --title="Build Podcast {{ post.title }}" --description="Show notes: http://build-podcast.com{{ post.permalink }}" --category="Tech" --keywords="{{ post.tags }}" ${videoFile##*/} > out.txt

# take the new youtube video url that was in out.txt
youtubeUrl=$(tail -n 1 out.txt)
youtubeCheckUrl="https://www.youtube.com/watch?v="

# add the new video to a youtube playlist
if [[ "${youtubeUrl:0:32}" == "$youtubeCheckUrl" ]]; then
  youtube-upload --email=sayanee@gmail.com --password=xxxxxxxx --add-to-playlist=http://gdata.youtube.com/feeds/api/playlists/PL9wSRifxQqRrLalGxTs-8FmfftbueLk5u $youtubeUrl
  echo "Uploaded video successfully!"
else
  echo "############### Something went wrong :( ################"
fi

rm ${videoFile##*/}

{% endfor %}
