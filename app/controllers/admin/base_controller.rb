class Admin::BaseController < ApplicationController
  before_action :require_admin

  private
    def require_admin
      redirect_to profile_path, alert: "You are not authorized to access that page." unless Current.user.admin?
    end
end
