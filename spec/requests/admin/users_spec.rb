require "rails_helper"

RSpec.describe "Admin users", type: :request do
  let(:admin) { create(:user, :admin) }

  before { sign_in(admin) }

  it "lists users for administrators" do
    user = create(:user)
    get admin_users_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(user.email)
  end

  it "creates a user" do
    expect do
      post admin_users_path, params: { user: { full_name: "Managed User", email: "managed@example.com", password: "SecurePass123!", password_confirmation: "SecurePass123!", role: "user" } }
    end.to change(User, :count).by(1)
  end

  it "renders errors when creation fails" do
    post admin_users_path, params: { user: { full_name: "", email: "invalid", password: "short", role: "user" } }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "shows and edits a user" do
    user = create(:user)

    get admin_user_path(user)
    expect(response).to have_http_status(:ok)

    get edit_admin_user_path(user)
    expect(response).to have_http_status(:ok)
  end

  it "updates a user" do
    user = create(:user)
    patch admin_user_path(user), params: { user: { full_name: "Managed Name", email: user.email, role: "admin" } }

    expect(response).to redirect_to(admin_user_path(user))
    expect(user.reload.full_name).to eq("Managed Name")
  end

  it "renders errors when an update fails" do
    user = create(:user)
    patch admin_user_path(user), params: { user: { full_name: "", email: "invalid", role: "user" } }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "toggles another user's role" do
    user = create(:user)
    patch toggle_role_admin_user_path(user)

    expect(user.reload).to be_admin
  end

  it "deletes another user" do
    user = create(:user)
    expect { delete admin_user_path(user) }.to change(User, :count).by(-1)
  end

  it "prevents administrators from changing their own role" do
    patch toggle_role_admin_user_path(admin)

    expect(admin.reload).to be_admin
    expect(response).to redirect_to(admin_users_path)
  end

  it "denies access to standard users" do
    delete session_path
    sign_in(create(:user))
    get admin_users_path

    expect(response).to redirect_to(profile_path)
  end

  it "renders the live dashboard" do
    get admin_dashboard_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("User dashboard")
  end
end
