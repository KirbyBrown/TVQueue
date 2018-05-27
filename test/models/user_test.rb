require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new( email: "valid.user@example.com",
                            password: "Test123" )
    @episode = Episode.new( tv_show_id: 1, season: 1, episode_number: 1, airdate: "9999-99-99", title: "Example Episode", still_path: nil )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com SFOIJSPDoi2@OSIJdpoisjfd]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMple.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end

  test "associated queued_episodes should be destroyed" do
    @user.save
    @user.queued_episodes.create!(episode: @episode)
    assert_difference 'QueuedEpisode.count', -1 do
      @user.destroy
    end
  end

  test "should queue and dequeue a show" do

  end

end
