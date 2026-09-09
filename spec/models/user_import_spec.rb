require "rails_helper"

RSpec.describe UserImport, type: :model do
  subject(:user_import) { described_class.new(creator: build(:user)) }

  it "requires a spreadsheet" do
    expect(user_import).not_to be_valid
    expect(user_import.errors[:spreadsheet]).to be_present
  end

  it "calculates progress as a percentage" do
    user_import.total_rows = 4
    user_import.processed_rows = 3

    expect(user_import.progress_percentage).to eq(75)
  end

  it "rejects unsupported file extensions" do
    user_import.spreadsheet.attach(io: StringIO.new("data"), filename: "users.txt", content_type: "text/plain")

    expect(user_import).not_to be_valid
    expect(user_import.errors[:spreadsheet]).to include("must be a CSV or XLSX file")
  end
end
