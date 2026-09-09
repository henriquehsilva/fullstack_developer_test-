require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it "shows only the authenticated profile" do
    get profile_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(user.full_name)
  end

  it "updates the authenticated profile" do
    patch profile_path, params: { user: { full_name: "Updated Name", email: user.email } }

    expect(response).to redirect_to(profile_path)
    expect(user.reload.full_name).to eq("Updated Name")
  end

  it "renders validation errors for invalid updates" do
    patch profile_path, params: { user: { full_name: "", email: "invalid" } }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "renders the edit form" do
    get edit_profile_path

    expect(response).to have_http_status(:ok)
  end

  it "deletes the authenticated account" do
    expect { delete profile_path }.to change(User, :count).by(-1)

    expect(response).to redirect_to(new_registration_path)
  end
end
