class SessionController < ApplicationController

  def new
  end

  def create

    # 1. Check if the email address entered is actually in the 'users' table
    user = User.find_by email: params[:email]

    # 2. Did we find a user with that email address (or was it nil), and if
    #    we did find a user, is the password correct?
    if user.present? && user.authenticate( params[:password] )
      # credentials were correct - successful login

      # Get Rails to create a new key/val pair in a special system variable called
      # 'session'; this variable is remembered ACROSS REQUESTS! (Unlike other controller
      # variables.) This stateful/persistent memory across requests is implemented
      # using browser cookies: the server asks the browser to set them (in a response header)
      # and the browser stores them, and presents them in every future request to that
      # same server (in a request header). I.e., we can remembered that we have logged in.
      session[:user_id] = user.id

      redirect_to home_path

    else
      # either the user was nil (no such email address), or the password didn't match
      # unsuccessful login

      redirect_to login_path   # show the login form again to correct errors

    end  # login check


  end # create


  def destroy
    session[:user_id] = nil   # This logs out the user
    redirect_to login_path    # Go back to the login form page
  end

end  # SessionController
