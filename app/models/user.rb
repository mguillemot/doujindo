class User < ActiveRecord::Base
  has_many :user_addresses, :dependent => :destroy

  validates_length_of :login, :within =>  3..40
  validates_length_of :password, :within => 6..40, :on => :create
  validates_presence_of :login, :email
  validates_uniqueness_of :login, :email
  validates_confirmation_of :password, :on => :create
  validates_format_of :email, :with => /^([^@\s]+)@([^@\s\.])+\.[a-z]{2,}$/i, :message => "Invalid email"

  attr_accessor :password, :password_confirmation
  attr_protected :password_salt

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirmed?
    email_confirmation_date.nil?
  end

  def regen_confirmation_key
    self.email_confirmation_key = Utils.random_string(16)
  end

  def password=(pass)
    @password = pass
    self.password_salt = Utils.random_string(10) if !self.password_salt?
    self.password_hash = Utils.hash_password(@password, self.password_salt)
  end

  def self.authenticate(login, pass)
    u = find(:first, :conditions => ['login = ?', login])
    return nil if u.nil?
    return u if Utils.hash_password(pass, u.password_salt) == u.password_hash
    nil
  end
end
