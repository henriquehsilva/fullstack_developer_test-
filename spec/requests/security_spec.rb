require "rails_helper"

RSpec.describe "Application security", type: :request do
  it "does not authenticate SQL injection payloads" do
    post session_path, params: { email: %q(' OR 1=1 --), password: "anything" }

    expect(response).to redirect_to(new_session_path)
    expect(cookies[:session_id]).to be_nil
  end

  it "escapes user-provided HTML in administrative pages" do
    admin = create(:user, :admin)
    create(:user, full_name: "<script>alert('xss')</script>")
    sign_in(admin)

    get admin_users_path

    expect(response.body).not_to include("<script>alert('xss')</script>")
    expect(response.body).to include("&lt;script&gt;")
  end

  it "enables request forgery protection outside the test environment" do
    expect(Rails.application.config.action_controller.default_protect_from_forgery).to be(true)
    expect(Rails.application.config.action_controller.forgery_protection_origin_check).to be(true)
  end
end
