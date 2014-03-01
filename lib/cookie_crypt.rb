module CookieCrypt

  def new_remember_token
    SecureRandom.urlsafe_base64
  end

  def encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
end