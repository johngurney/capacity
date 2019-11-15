class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def encrypt(unencrypted_content)
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.encrypt_and_sign(unencrypted_content)
  end


  def decrypt(encrypted_content)
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(encrypted_content)
  end

end
