class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: "You should be signed in" if current_user.nil?
  end

  def ensure_that_user_is_admin
    redirect_to root_path, notice: "You need to be an admin to perform this action" unless current_user&.admin
  end

  def expire_brewery_list_cache
    expire_fragment("brewerylist")
  end
end
