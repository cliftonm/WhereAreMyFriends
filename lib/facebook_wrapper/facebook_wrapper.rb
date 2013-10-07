module FacebookWrapperModule
  class FacebookWrapper
    # Returns an array of friends, the array structure is that returned by Facebook from FQL.
    # Example usage: fb_friends = FacebookWrapper.get_fb_friends
    def self.get_fb_friends(oauth_token)
      options = {access_token: oauth_token}
      friends = Fql.execute("SELECT uid, name, pic_square, current_address, current_location, hometown_location, profile_url FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())", options)

      friends
    end

    # Given an array of Facebook friends, returns an array of model instances, the model instance being
    # instantiated by the application as a callback.
    def self.from_fb_friends(fb_friends)
      friends = []
      fb_friends.each do |fb_friend|
        location = get_location_or_hometown_address(fb_friend)

        if !location.nil?
          friend = yield(fb_friend, location)
          friends << friend
        end
      end

      friends
    end

    private

    def self.get_location_or_hometown_address(fb_friend)
      location = fb_friend["current_location"]

      if location.nil?
        location = fb_friend["hometown_location"]
      end

      location
    end
  end
end