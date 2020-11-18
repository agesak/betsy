require "test_helper"

describe UsersController do
  describe 'login' do
    it 'can log in an existing user' do
      user = perform_login(users(:ada))

      must_respond_with :redirect
    end

    it 'can log in an new user' do
      new_user = User.new(uid: '1111', username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      expect {
        logged_in_user = perform_login(new_user)
      }.must_change 'User.count', 1

      must_respond_with :redirect
    end

    it 'redirects to root path if given invalid user data' do
      # Arrange - invalid user (uid is nil)
      start_count = User.count

      user = User.new(uid: nil, username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      # send login request for that user
      get omniauth_callback_path(:github)

      #must_redirect_to root_path

      # find the new user in the DB
      user = User.find_by(uid: user.uid, provider: user.provider)

      # Make sure the user is nil
      expect(user).must_equal nil

      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal nil

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    #NOTES: testing negative cases
    # Someone making a get request to the callback route without coming from the Auth provider (no auth_hash).
    # A request with an invalid auth provider `get auth_callback_path(:bogus)
    # A request with an invalid auth_hash, like missing a uid.
  end

  describe 'logout' do
    it 'can logout an existing user' do
      perform_login()

      # before logging out
      expect {session[:user_id]}.wont_be_nil

      post logout_path, params: {} # log out

      expect {session[:user_id]}.must_be_nil
    end
  end



end
