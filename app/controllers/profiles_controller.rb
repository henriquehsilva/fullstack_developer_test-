class ProfilesController < ApplicationController
  before_action :set_user

  def show; end

  def edit; end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = @user
    terminate_session
    user.destroy!
    redirect_to new_registration_path, notice: "Your account was deleted."
  end

  private
    def set_user
      @user = Current.user
    end

    def profile_params
      params.expect(user: [ :full_name, :email, :password, :password_confirmation, :avatar_url, :avatar_image ])
        .compact_blank
    end
end
