require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_valid }

  it "normalizes email addresses" do
    user.email = "  USER@Example.COM "
    user.validate

    expect(user.email).to eq("user@example.com")
  end

  it "rejects invalid email addresses" do
    user.email = "not-an-email"

    expect(user).not_to be_valid
    expect(user.errors[:email]).to be_present
  end

  it "requires a full name" do
    user.full_name = ""

    expect(user).not_to be_valid
  end

  it "requires passwords to contain at least eight characters" do
    user.password = "short"

    expect(user).not_to be_valid
  end

  it "defaults to the user role" do
    expect(described_class.new.role).to eq("user")
  end

  it "rejects unsupported avatar URL schemes" do
    user.avatar_url = "javascript:alert(1)"

    expect(user).not_to be_valid
  end

  it "uses a remote avatar URL when no upload is attached" do
    user.avatar_url = "https://example.com/avatar.png"

    expect(user.avatar_source).to eq("https://example.com/avatar.png")
  end

  it "rejects unsupported uploaded image types" do
    user.avatar_image.attach(io: StringIO.new("plain text"), filename: "avatar.txt", content_type: "text/plain")

    expect(user).not_to be_valid
    expect(user.errors[:avatar_image]).to include("must be a JPEG, PNG, or WebP image")
  end
end
