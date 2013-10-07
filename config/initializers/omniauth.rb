Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'friends_location, friends_hometown, user_friends, email, user_likes',
           :display => 'popup'
end

