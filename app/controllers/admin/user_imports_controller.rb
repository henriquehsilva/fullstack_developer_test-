class Admin::UserImportsController < Admin::BaseController
  before_action :set_user_import, only: :show
  def index = @user_imports = UserImport.with_attached_spreadsheet.order(created_at: :desc)
  def new = @user_import = UserImport.new
  def show; end

  def create
    @user_import = UserImport.new(import_params.merge(creator: Current.user))
    if @user_import.save
      UserImportJob.perform_later(@user_import)
      redirect_to admin_user_import_path(@user_import), notice: "Import queued successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_user_import = @user_import = UserImport.find(params[:id])
    def import_params = params.expect(user_import: [ :spreadsheet ])
end
