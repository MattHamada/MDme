module JsonHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def my_encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
end