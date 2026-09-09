require "rails_helper"

RSpec.describe "Password resets", type: :request do
  it "renders the request form" do
    get new_password_path

    expect(response).to have_http_status(:ok)
  end

  it "queues reset instructions without revealing account existence" do
    user = create(:user)

    expect do
      post passwords_path, params: { email: user.email }
    end.to have_enqueued_mail(PasswordsMailer, :reset).with(user)

    expect(response).to redirect_to(new_session_path)
  end

  it "returns the same response for an unknown email" do
    expect do
      post passwords_path, params: { email: "unknown@example.com" }
    end.not_to have_enqueued_mail

    expect(response).to redirect_to(new_session_path)
  end

  it "resets a password with a valid token" do
    user = create(:user)
    token = user.password_reset_token

    put password_path(token), params: { password: "NewSecurePass123!", password_confirmation: "NewSecurePass123!" }

    expect(response).to redirect_to(new_session_path)
    expect(user.reload.authenticate("NewSecurePass123!")).to eq(user)
  end

  it "rejects a mismatched password confirmation" do
    user = create(:user)
    token = user.password_reset_token

    put password_path(token), params: { password: "NewSecurePass123!", password_confirmation: "different" }

    expect(response).to redirect_to(edit_password_path(token))
  end

  it "rejects an invalid token" do
    get edit_password_path("invalid-token")

    expect(response).to redirect_to(new_password_path)
  end
end
