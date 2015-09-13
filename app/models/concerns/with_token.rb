module WithToken
  def get_token
    Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end