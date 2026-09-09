require "rails_helper"

RSpec.describe "Admin user imports", type: :request do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in(admin)
    ActiveJob::Base.queue_adapter = :test
  end

  it "queues a CSV import" do
    file = fixture_file_upload(Rails.root.join("spec/fixtures/files/users.csv"), "text/csv")

    expect do
      post admin_user_imports_path, params: { user_import: { spreadsheet: file } }
    end.to have_enqueued_job(UserImportJob)

    expect(response).to redirect_to(admin_user_import_path(UserImport.last))
  end
end
