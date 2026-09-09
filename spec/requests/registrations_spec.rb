require "rails_helper"

RSpec.describe "Registrations", type: :request do
  it "registers visitors as standard users" do
    expect do
      post registration_path, params: { user: { full_name: "New User", email: "new@example.com", password: "SecurePass123!", password_confirmation: "SecurePass123!" } }
    end.to change(User, :count).by(1)

    expect(User.last).to be_user
    expect(response).to redirect_to(profile_path)
  end

  it "renders validation errors for invalid input" do
    post registration_path, params: { user: { full_name: "", email: "invalid", password: "short", password_confirmation: "other" } }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "shows the registration form to visitors" do
    get new_registration_path

    expect(response).to have_http_status(:ok)
  end
end
