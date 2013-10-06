class MapMyFriendsController < ApplicationController
  def index
    fb_friends = get_fb_friends
    @friends = get_friends(fb_friends)

    @json = @friends.to_gmaps4rails
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friends }
    end
  end

  def get_fb_friends
    options = {access_token: "CAACEdEose0cBANKyCMDxWPWaagZAl3uV7DjrZCKbBuFnVKbwShklj1qztfNpbL5VSnsEuDDRi40v0bsZCE1DwANY1if86jZA1hvWm5HWIO0xwfZC43NPsHv5ptjH2gXbryEzyD9AY40VyhKnszZCw2GlgO6XsN8VDozncZCd6l5cFKytLiOAVbZBwwknnoviAo3uWZBd6r1vMKgZDZD"}
    friends = Fql.execute("SELECT uid, name, pic_square, current_address, current_location, hometown_location FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())", options)
  end

  def get_friends(fb_friends)
    friends = []
    fb_friends.each do |fb_friend|
      location = get_location_or_hometown_address(fb_friend)

      if !location.nil?
        friend = Friend.new
        friend.uid = fb_friend["uid"]
        friend.name = fb_friend["name"]
        friend.pic = fb_friend["pic_square"]
        friend.address = location["name"]
        friend.latitude = location["latitude"]
        friend.longitude = location["longitude"]
        friend.gmaps = true

        friends << friend
      end
    end

    friends
  end

  def get_location_or_hometown_address(fb_friend)
    location = fb_friend["current_location"]

    if location.nil?
      location = fb_friend["hometown_location"]
    end

    location
  end
end
