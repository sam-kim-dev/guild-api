class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  def authenticate_user!
    return if (@current_user = User.first)

    render file: "public/404.html", status: :not_found, layout: false
  end
end
