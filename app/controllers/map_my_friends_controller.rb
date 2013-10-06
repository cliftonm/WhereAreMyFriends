require 'facebook_wrapper'
include FacebookWrapperModule

class MapMyFriendsController < ApplicationController
  def index
    fb_friends = FacebookWrapper.get_fb_friends
    @friends = FacebookWrapper.from_fb_friends(fb_friends) { |fb_friend, location|
      friend = Friend.new
      friend.uid = fb_friend["uid"]
      friend.name = fb_friend["name"]
      friend.pic = fb_friend["pic_square"]
      friend.profile_url = fb_friend["profile_url"]
      friend.address = location["name"]
      friend.latitude = location["latitude"]
      friend.longitude = location["longitude"]
      friend.gmaps = true

      friend
    }

    @json = @friends.to_gmaps4rails
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friends }
    end
  end
end
