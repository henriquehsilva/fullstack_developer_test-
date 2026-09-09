require "rails_helper"

RSpec.describe "Authentication", type: :request do
  it "redirects an administrator to the dashboard after login" do
    admin = create(:user, :admin)

    sign_in(admin)

    expect(response).to redirect_to(admin_dashboard_url)
  end

  it "redirects a standard user to their profile after login" do
    user = create(:user)

    sign_in(user)

    expect(response).to redirect_to(profile_url)
  end

  it "rejects invalid credentials without leaking account existence" do
    post session_path, params: { email: "missing@example.com", password: "wrong" }

    expect(response).to redirect_to(new_session_path)
    expect(flash[:alert]).to eq("Try another email address or password.")
  end
end
