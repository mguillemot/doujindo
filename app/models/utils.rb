class Utils
  def self.hash_password(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end

  def self.random_string(len)
    chars = ('a'..'z').to_a + ('0'..'9').to_a
    newpass = '';
    1.upto(len) { |i| newpass << chars[rand(chars.size - 1)] }
    return newpass
  end
end