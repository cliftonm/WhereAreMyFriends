class SessionsController < ApplicationController
  def new
    redirect_to '/auth/facebook'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    # don't use User.find, as this throws an exception, RecordNotFound
    user = User.find_by_id(session[:user_id])

    if !user.nil?
      User.find(session[:user_id]).delete
      reset_session
      session[:user_id] = nil
    end

    redirect_to root_url, notice: 'Signed out!'
  end
end
