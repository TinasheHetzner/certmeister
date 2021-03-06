require 'certmeister/policy/response'

module Certmeister

  module Policy

    class Psk

      def initialize(psks)
        validate_psks(psks)
        @psks = psks.map(&:to_s)
      end

      def authenticate(request)
        if not request[:psk]
          Certmeister::Policy::Response.new(false, "missing psk")
        elsif not @psks.include?(request[:psk])
          Certmeister::Policy::Response.new(false, "unknown psk")
        else
          Certmeister::Policy::Response.new(true, nil)
        end
      end

      private

      def validate_psks(psks)
        unless psks.is_a?(Enumerable) and psks.respond_to?(:size) and psks.size > 0 and
               psks.all? { |psk| psk.respond_to?(:to_s) }
          raise ArgumentError.new("enumerable collection of psks required")
        end
      end

    end

  end

end
