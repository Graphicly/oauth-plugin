class Oauth2RefreshToken < AccessToken
  def as_json(options={})
    d = {:refresh_token=>token}
    d[:expires_in] = expires_in if expires_at
    d
  end
  
  def to_query
    q = "refresh_token=#{token}"
    q << "&expires_in=#{expires_in}" if expires_at
    q << "&scope=#{URI.escape(scope)}" if scope
    q
  end
  
  def expires_in
    expires_at.to_i - Time.now.to_i
  end
end