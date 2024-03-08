require 'base64'
require 'digest'
require 'json'
require 'openssl'
class CypeController < ApplicationController

  skip_before_action :verify_authenticity_token

  def encrypt
    password = 'key'
    payload = {
      doctype: params[:doctype],
      name: params[:name],
      dob: params[:dob],
      pan: params[:pan]
    }

    encrypted_data = encrypt_data(payload, password)
    render json: { status: 'success', encrypted_data: encrypted_data }
  end

  def decrypt
    password = 'key'
    encrypted_data = params[:encrypted_data]
  
    decrypted_data = decrypt_data(encrypted_data, password)
    render json: { status: 'success', decrypted_data: decrypted_data }
  end

  private

  def encrypt_data(payload, password)
    cipher = AESCipher.new(password)
    cipher.encrypt(payload.to_json)
  end

  def decrypt_data(encrypted_data, password)
    cipher = AESCipher.new(password)
    decrypted_payload = cipher.decrypt(encrypted_data)
    JSON.parse(decrypted_payload)
  end
end

class AESCipher
  def initialize(key)
    @key = Digest::SHA512.hexdigest(key.encode('utf-8'))[0, 16].encode('utf-8')
  end

  def encrypt(raw)
    raw = raw.to_s
    iv = OpenSSL::Random.random_bytes(16) 
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = @key
    cipher.iv = iv

    encrypted = cipher.update(raw.encode("utf-8")) + cipher.final
    encrypted_payload = Base64.strict_encode64(encrypted)
    
    encrypted_iv = Base64.strict_encode64(iv)
    colon_encoding = ":".encode("utf-8")
    (encrypted_payload + colon_encoding + encrypted_iv).encode('utf-32')
  end

  def decrypt(enc)
    enc_payload, enc_iv = enc.split(':')
    encrypted_payload = Base64.strict_decode64(enc_payload)
    iv = Base64.strict_decode64(enc_iv)

    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.decrypt
    cipher.key = @key
    cipher.iv = iv
    decrypted = cipher.update(encrypted_payload) + cipher.final
  end
end
