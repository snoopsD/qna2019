module OmniauthHelpers
  def mock_auth(provider, email = nil)
    hash = {
      'provider' => provider.to_s,
      'uid' => '123545'
    }

    if provider == :github
      hash.merge!('info' => { 'email' => 'test@test.ru' }) 
    end  

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(hash)
  end
end
