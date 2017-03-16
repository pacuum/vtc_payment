require "openssl"
require "digest"
require "base64"

module VtcPayment
  module MobileCard
    class Crypt
      class << self
        def encrypt( input, seed )
          # padding
          input = input.to_s.strip;
          # it seems openssl automatically pad the string in the same way as php sample code
          # input = input.to_s.ljust 8, '-'

          # encrypt
          cipher = OpenSSL::Cipher.new 'des-ede3' # tripledes-ebc
          cipher.encrypt
          cipher.key = md5_key(seed)
          encrypted = cipher.update(input) + cipher.final  # .unpack("H*")

          return Base64.encode64(encrypted).gsub("\n", "");
        end

        # generate a 24 byte key from the md5 of the seed
        def md5_key(seed)
          Digest::MD5.hexdigest(seed).to_s[0,24]
        end

        def decrypt( encoded, seed )
          encrypted = Base64.decode64(encoded)

          key = md5_key(seed)

          cipher = OpenSSL::Cipher.new 'des-ede3' # tripledes-ebc
          cipher.decrypt
          cipher.key = key
          plain = cipher.update(encrypted) + cipher.final  # .unpack("H*")

          plain
        end
      end
    end
  end
end
