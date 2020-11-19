require "test_helper"

describe User do
  describe 'validations' do
    it 'is valid when all fields are present' do
      new_user = User.new(uid: '1111', username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      status = new_user.valid?
      expect(status).must_equal true

      expect {
        new_user.save
      }.must_change 'User.count', 1

    end

    it 'is invalid if missing uid' do
      # this should be a model/validtions text
      user = User.new(uid: nil, username: 'new_user', provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false
    end

    it 'is invalid if missing username' do
      # this should be a model/validtions text
      user = User.new(uid: '11111111', username: nil, provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false
    end

    it 'is invalid if missing email' do
      user = users(:ada)
      user.email = nil

      expect(user.valid?).must_equal false

    end

    it 'is invalid if username is not unique' do
      user = User.new(uid: '11111111', username: 'ada', provider: 'github', image: 'some string', email: 'test@test.com')

      expect(user.valid?).must_equal false

    end

    it 'is invalid if email address is not unique' do
      user = User.new(uid: '11111111', username: 'new_name', provider: 'github', image: 'some string', email: 'ada@adadev.org')

      expect(user.valid?).must_equal false
    end

  end

  describe 'relations' do
    it 'can have many products' do
      #use fixtures yml data
      user = users(:ada)

      expect(user.products.count).must_equal 3
    end

  end
end
