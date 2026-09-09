require "rails_helper"

RSpec.describe "User registration", type: :system do
  it "allows a visitor to create an account and view their profile" do
    visit new_registration_path

    fill_in "Full name", with: "Browser User"
    fill_in "Email", with: "browser@example.com"
    fill_in "Password", with: "SecurePass123!"
    fill_in "Password confirmation", with: "SecurePass123!"
    click_button "Create account"

    expect(page).to have_current_path(profile_path)
    expect(page).to have_content("Browser User")
  end
end
