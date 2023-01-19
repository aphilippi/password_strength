class User
  include ActiveModel::Validations

  attr_accessor :username, :password, :login, :email

  def initialize(attributes = {})
    update(attributes)
  end

  def update(attributes = {})
    attributes.each { |name, value| public_send "#{name}=", value }
    valid?
  end
end
