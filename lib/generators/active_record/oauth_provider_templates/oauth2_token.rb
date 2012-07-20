class Oauth2Token < AccessToken
  attr_accessor :state
  attr_accessor :refresh_token
  
  before_validation :generate_refresh_token, :on => :create
  
  def as_json(options={})
    d = {:access_token => token, :refresh_token => @refresh_token.token, :token_type => 'bearer'}
    d[:expires_in] = expires_in if expires_at
    d
  end

  def to_query
    q = "access_token=#{token}&refresh_token=#{@refresh_token.token}&token_type=bearer"
    q << "&state=#{URI.escape(state)}" if @state
    q << "&expires_in=#{expires_in}" if expires_at
    q << "&scope=#{URI.escape(scope)}" if scope
    q
  end

  def expires_in
    expires_at.to_i - Time.now.to_i
  end
  
  def generate_refresh_token
    @refresh_token = Oauth2RefreshToken.create! :user => user, :client_application => client_application, :scope => scope
  end
end
