class ChangeUser
  include ActiveModel::Model
  attr_accessor :name

  def initialize(user)
    @name = user[:user]
  end
end
