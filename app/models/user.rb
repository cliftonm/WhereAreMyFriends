class User < ActiveRecord::Base
  attr_accessible :email, :name, :oauth_token, :provider, :uid

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token

      if auth.info
        user.name = auth.info.name || ''
        user.email = auth.info.email || ''
      end
    end
  end

end
