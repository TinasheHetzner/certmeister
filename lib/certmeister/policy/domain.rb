require 'certmeister/policy/response'

module Certmeister

  module Policy

    class Domain

      def initialize(domains)
        validate_domains(domains)
        @domains = domains.map { |domain| ".#{domain}" }
      end

      def authenticate(request)
        if not request[:cn]
          Certmeister::Policy::Response.new(false, "missing cn")
        elsif not @domains.any? { |domain| request[:cn].end_with?(domain) }
          Certmeister::Policy::Response.new(false, "cn in unknown domain")
        else
          Certmeister::Policy::Response.new(true, nil)
        end
      end

      private

      def validate_domains(domains)
        unless domains.is_a?(Enumerable) and domains.respond_to?(:size) and domains.size > 0 and
               domains.all? { |psk| psk.respond_to?(:to_s) }
          raise ArgumentError.new("enumerable collection of domains required")
        end
      end

    end

  end

end
