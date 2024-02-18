require 'rbnacl'
require 'base64'
require 'json'

module Todo
  class JWTCredential
    def Initialize
      base64_key = ENV['JWT_KEY']
      raise 'JWT_KEY is not set in the environment.' unless base64_key
      decoded_key = Base64.strict_decode64(base64_key)
      signing_key = RbNaCl::SigningKey.new(decoded_key)
    end

    def self.generate_key
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      hex_key = key.unpack1("H*")
    end

    def self.generate_jwt(account_id, roles)
      key = Base64.strict_decode64(ENV['JWT_KEY'])
      secret_box = RbNaCl::SecretBox.new(key)
      
      payload = { account_id: account_id, roles: roles }.to_json
      nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
      encrypted_payload = secret_box.encrypt(nonce, payload)

      Base64.urlsafe_encode64(nonce + encrypted_payload)
    end

    def self.decode_jwt(token)
      key = Base64.strict_decode64(ENV['JWT_KEY'])
      secret_box = RbNaCl::SecretBox.new(key)
      
      decoded_data = Base64.urlsafe_decode64(token)
      nonce = decoded_data.slice!(0, secret_box.nonce_bytes)
      decrypted_payload = secret_box.decrypt(nonce, decoded_data)
      
      # Return the decrypted payload as a JSON object
      JSON.parse(decrypted_payload)
    rescue RbNaCl::CryptoError
      raise 'Decryption failed. Invalid token or key.'
    end
  end
end
