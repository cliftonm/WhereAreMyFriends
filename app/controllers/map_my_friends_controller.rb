require 'facebook_wrapper'
include FacebookWrapperModule

class MapMyFriendsController < ApplicationController
  def index
    user_id = session[:user_id]
    @friends = []

    if !user_id.nil?
      oauth_token = User.find(user_id).oauth_token
      @friends = get_friends(oauth_token)
    end

    @json = @friends.to_gmaps4rails
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friends }
    end
  end

  private

  def get_friends(oauth_token)
    fb_friends = FacebookWrapper.get_fb_friends(oauth_token)
    friends = FacebookWrapper.from_fb_friends(fb_friends) { |fb_friend, location|
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

    friends
  end
end
