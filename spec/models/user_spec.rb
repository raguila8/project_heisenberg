require "rails_helper"

RSpec.describe User do
  let (:user) { FactoryBot.build_stubbed(:user) }

  describe "username" do
    it "should not be nil" do
      user.username = nil
      expect(user.valid?).not_to be_truthy
      user.username = "rodrigo"
      expect(user.valid?).to be_truthy
    end

    it "should not have an empty username" do
      user.username = ""
      expect(user.valid?).not_to be_truthy
    end

    it "should have a username of length at least 5" do
      user.username = "a" * 4
      expect(user.valid?).not_to be_truthy
      user.username = "a" * 5
      expect(user.valid?).to be_truthy
    end

    it "should not have a long username" do
      user.username = "a" * 18
      expect(user.valid?).to be_truthy
      user.username = "a" * 19
      expect(user.valid?).not_to be_truthy
    end

    it "should be unique" do
      FactoryBot.create(:user, username: "foobar")
      user.username = "foobar"
      expect(user.valid?).not_to be_truthy
      user.username = "FOOBAR"
      expect(user.valid?).not_to be_truthy    # username is case insensitive
    end
  end

  describe "email" do
    it "should not be nil" do
      user.email = nil
      expect(user.valid?).not_to be_truthy
    end

    it "should not be empty" do
      user.email = ""
      expect(user.valid?).not_to be_truthy
    end

    it "should not be too long" do
      user.email = "a" * 244 + "@example.com"
      expect(user.valid?).not_to be_truthy
    end

    it "should have valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to be_truthy, 
             "#{valid_address.inspect} should be valid"
      end
    end

    it "should not have invalid addresses" do
      invalid_addresses = %w[user@example,com 
                             user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).not_to be_truthy, 
             "#{invalid_address.inspect} should be invalid"
      end
    end

    it "should be unique" do
      FactoryBot.create(:user, email: "foobar@example.com")
      user.email = "FOOBAR@EXAMPLE.COM"    # case insensitive
      expect(user.valid?).not_to be_truthy 
    end
  end

  describe "bio" do
    it "should not be too long" do
      user.bio = "a" * 501
      expect(user.valid?).not_to be_truthy 
    end
  end

  describe "name" do
    it "should not be too long" do
      user.name = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end
  end

  describe "occupation" do
    it "should not be too long" do
      user.occupation = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end
  end

  describe "school" do
    it "should not be too long" do
      user.school = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end
  end
end
