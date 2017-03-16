# handle notification
module VtcPayment
	class NotificationParser

		def initialize(secret_key, mode = :notification)
			@secret_key = secret_key
			@mode = mode
		end

		# when data is sent through http,
		NOTIFICATION_SEPARATOR = "|" # the result from backend notification api
		USER_SEPARATOR = "-" # the result from redirected user
		def separator
			if @mode == :notification
				NOTIFICATION_SEPARATOR
			elsif @mode == :user
				USER_SEPARATOR
			else
				raise "invalid mode: #{@mode.inspect}"
			end
		end

		def parse_users_request(params)
			@mode = :user
			status, website_id, order_id, amount, sign = params.values_at(%w(status website_id order_code amount sign))
			data = [ status, website_id, order_id, amount ].join(separator)
			parse_notification( data, sign )
		end

		def parse_notification(data, signature)
			log data, signature
			my_signature = Digest::SHA256.hexdigest("#{data}#{separator}#{@secret_key}")
			if( signature != my_signature )
				logger.error [ "failed to verify signature", signature, my_signature, Digest::MD5.new(@secret_key.to_s).to_s].to_json
				raise "signature verification failed. Wrong secret_key?"
			end

			status, amount, _ =  data.split(separator)

			logger.error [ "result_parsed", status.to_s, amount.to_s ].to_json
			return Result.new(status)
		end

		def log( data, signature )
			logger.info [ data, signature, @mode ].to_json
		end

    def logger
      @logger ||= Logger.new("vtc_notification.log")
    end

		class Result
			attr_reader :code
			def initialize(code)
				raise "code must be a positive or negative number" if code.to_s !~ /\A\-?\d+\z/ # only numbers
				@code = code.to_i
			end
			def successful?
				@code == 1 || @code == 2 || @code == 7
			end

      # https://pay.vtc.vn/content/integrated/TichHopWebSite_v10_vi.pdf
			MESSAGES = {
				1 => "successful",
				2 => "successful pending",
				0 => "pending",
				-1 => "failed",
				-5 => "order is not valid",
				-6 => "not enough balance",
			}

			def message
				MESSAGES[@code] || "unknown"
			end
		end

	end
end
