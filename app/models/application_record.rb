class ApplicationRecord < ActiveRecord::Base
  @@crypt = nil
  self.abstract_class = true

  def encrypt(unencrypted_content)
    make_crypt
    @@crypt.encrypt_and_sign(unencrypted_content)
  end

  def decrypt(encrypted_content)
    make_crypt
    @@crypt.decrypt_and_verify(encrypted_content)
  end

  def make_crypt
    if @@crypt.blank?
      puts "%%%%%******"
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key Rails.configuration.encryption_salt, Rails.configuration.encryption_key_length
      @@crypt = ActiveSupport::MessageEncryptor.new(key)
    end

  end

end
