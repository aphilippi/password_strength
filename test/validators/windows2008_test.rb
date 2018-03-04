require "test_helper"

class Window2008Test < Minitest::Test
  def setup
    PasswordStrength.enabled = true
    Object.class_eval { remove_const("User") } if defined?(User)
    load "user.rb"
    User.validates_strength_of :password, :using => PasswordStrength::Validators::Windows2008

    @user = User.new(:username => "Administrator")
  end

  def test_require_password_to_include_three_character_categories
    @user.update :password => "abcABC"
    assert @user.errors.full_messages.any?

    @user.update :password => "abc123"
    assert @user.errors.full_messages.any?

    @user.update :password => "abc$!~"
    assert @user.errors.full_messages.any?

    @user.update :password => "123ABC"
    assert @user.errors.full_messages.any?

    @user.update :password => "123$!~"
    assert @user.errors.full_messages.any?

    @user.update :password => "ABC$!~"
    assert @user.errors.full_messages.any?
  end

  def test_invalidate_password_that_includes_username
    @user.update :password => "abc$!~ABC123Admin"
    assert @user.errors.full_messages.any?

    @user.update :password => "abc$!~ABC123Adm"
    assert @user.errors.full_messages.any?

    @user.update :password => "abc$!~ABC123admin"
    assert @user.errors.full_messages.any?
  end

  def test_invalidate_short_passwords
    @user.update :password => "12345"
    assert @user.errors.full_messages.any?
  end

  def test_accept_numbers_uppercases_and_lowercases
    @user.update :password => "123ABCabc"
    assert @user.valid?
  end

  def test_accept_numbers_uppercases_and_special_chars
    @user.update :password => "123ABC$!~"
    assert @user.valid?
  end

  def test_accept_numbers_lowercases_and_special_chars
    @user.update :password => "123ABC$!~"
    assert @user.valid?
  end

  def test_accept_uppercases_lowercases_and_special_chars
    @user.update :password => "ABCabc$!~"
    assert @user.valid?
  end
end
