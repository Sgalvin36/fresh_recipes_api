class User < ApplicationRecord
  enum role: { admin: 0, user: 1 }
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  validates :role, inclusion: { in: User.roles.keys }
  has_secure_password
  has_secure_token :key


  after_initialize :set_default_role, if: :new_record?

  private
  def set_default_role
    self.role ||= :user
  end
end