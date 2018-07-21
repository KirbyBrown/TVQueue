require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "email_confirmation" do
    user = users(:one)
    user.confirmation_token = User.new_token
    mail = UserMailer.email_confirmation(user)
    assert_equal "Email Confirmation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@tvqueue.ninja"], mail.from
    assert_match user.email,                mail.body.encoded
    assert_match CGI.escape(user.email),    mail.body.encoded
  end

#  test "password_reset" do
#    mail = UserMailer.password_reset
#    assert_equal "Password reset", mail.subject
#    assert_equal ["to@example.org"], mail.to
#    assert_equal ["from@example.com"], mail.from
#    assert_match "Hi", mail.body.encoded
#  end

end
