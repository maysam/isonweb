class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login
    user = AdminUser.find_by email: params[:email]
    if user and user.valid_password? params[:password]
      render json: {id: user.id}
    else
      render json: false
    end
  end

end
