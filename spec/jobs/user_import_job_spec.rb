require "rails_helper"

RSpec.describe UserImportJob, type: :job do
  it "imports valid rows and records invalid rows" do
    user_import = UserImport.new(creator: create(:user, :admin))
    csv = <<~CSV
      full_name,email,role,avatar_url
      Imported Admin,imported-admin@example.com,admin,
      Invalid User,not-an-email,user,
    CSV
    user_import.spreadsheet.attach(io: StringIO.new(csv), filename: "users.csv", content_type: "text/csv")
    user_import.save!

    expect { described_class.perform_now(user_import) }.to change(User, :count).by(1)

    expect(user_import.reload).to be_completed
    expect(user_import.processed_rows).to eq(2)
    expect(user_import.failed_rows).to eq(1)
    expect(User.find_by(email: "imported-admin@example.com")).to be_admin
  end

  it "marks imports with missing headers as failed" do
    user_import = UserImport.new(creator: create(:user, :admin))
    user_import.spreadsheet.attach(io: StringIO.new("name\nMissing Email"), filename: "users.csv", content_type: "text/csv")
    user_import.save!

    expect { described_class.perform_now(user_import) }.to raise_error(ArgumentError, /Missing required columns/)
    expect(user_import.reload).to be_failed
  end
end
