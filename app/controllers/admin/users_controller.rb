class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[ show edit update destroy toggle_role ]

  def index
    @users = User.with_attached_avatar_image.order(created_at: :desc)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params.compact_blank)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to(admin_users_path, alert: "You cannot delete your own account.") if @user == Current.user

    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted successfully."
  end

  def toggle_role
    return redirect_to(admin_users_path, alert: "You cannot change your own role.") if @user == Current.user

    @user.update!(role: @user.admin? ? :user : :admin)
    redirect_to admin_users_path, notice: "#{@user.full_name} is now #{@user.role}."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      permitted = params.expect(user: [ :full_name, :email, :password, :password_confirmation, :role, :avatar_url, :avatar_image ])
      permitted.delete(:role) unless User.roles.key?(permitted[:role])
      permitted
    end
end
