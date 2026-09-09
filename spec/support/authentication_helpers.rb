module AuthenticationHelpers
  def sign_in(user, password: "SecurePass123!")
    post session_path, params: { email: user.email, password: password }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
  config.before(type: :request) { host! "localhost" }
end
