require 'devise'

module ValidUserRequestHelper
  # Define a method which signs in as a valid user.
  def sign_in_as_a_valid_user
    # ASk factory girl to generate a valid user for us.
    @user ||= FactoryGirl.create :user

    # We action the login request using the parameters before we begin.
    # The login requests will match these to the user we just created in the factory, and authenticate us.
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end
end

module ControllerHelper
  def login_as(role)
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create role
      sign_in user
    end
  end
end

# Configure these to modules as helpers in the appropriate tests.
RSpec.configure do |config|
# Include the help for the request specs.
  config.include ValidUserRequestHelper, type: :request
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerHelper, type: :controller
  config.include Devise::TestHelpers, type: :view
end