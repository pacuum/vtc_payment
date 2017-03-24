# handle notification
module VtcPayment
  class NotificationParser

    def initialize(secret_key, mode = :notification)
      @secret_key = secret_key
    end

    # when data is sent through http,
    NOTIFICATION_SEPARATOR = "|" # the result from backend notification api
    USER_SEPARATOR = "-" # the result from redirected user
    def parse_users_request(params)
      separator = USER_SEPARATOR
      status, website_id, order_id, amount, sign = params.values_at(%w(status website_id order_code amount sign))
      data = [ status, website_id, order_id, amount ].join(separator)
      verify_signature(data, signature, separator)
      logger.error [ "result_parsed", status.to_s, amount.to_s ].to_json
      return Result.new(order_id, status, amount)
    end

    def parse_notification(data, signature)
      separator = NOTIFICATION_SEPARATOR
      logger.info [ "notification received", data, signature ].to_json
      verify_signature(data, signature, separator)
      order_id, status, amount, _ =  data.split(separator)

      logger.error [ "result_parsed", status.to_s, amount.to_s ].to_json
      return Result.new(order_id, status, amount)
    end

    def verify_signature(data, signature, separator)
      logger.info [ :verify_signature, data, signature ].to_json
      my_signature = Digest::SHA256.hexdigest("#{data}#{separator}#{@secret_key}")
      if( signature != my_signature )
        logger.error [ "failed to verify signature", signature, my_signature, Digest::MD5.new(@secret_key.to_s).to_s].to_json
        raise "signature verification failed. Wrong secret_key?"
      end
    end

    def logger
      @logger ||= Logger.new("#{log_dir}/vtc_notification.log")
    end

    def log_dir
      if defined?(Rails)
        "#{Rails.root}/log"
      else
        "."
      end
    end

    class Result
      attr_reader :order_id, :amount, :code
      def initialize(order_id, amount, code)
        raise "code must be a positive or negative number" if code.to_s !~ /\A\-?\d+\z/ # only numbers
        @order_id = order_id
        @amount = amount
        @code = code.to_i
      end

      def successful?
        @code > 0
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
