require 'certmeister/store_error'

module Certmeister

  class InMemoryStore

    include Enumerable

    def initialize(certs = {})
      @certs = certs
      @healthy = true
    end

    def store(cn, cert)
      fail_if_unhealthy
      @certs[cn] = cert
    end

    def fetch(cn)
      fail_if_unhealthy
      @certs[cn]
    end

    def remove(cn)
      fail_if_unhealthy
      !!@certs.delete(cn)
    end

    def each
      @certs.each do |cn, cert|
        yield cn, cert
      end
    end

    def health_check
      @healthy
    end

    private

    def break!
      @healthy = false
    end

    def fail_if_unhealthy
      raise Certmeister::StoreError.new("in-memory store is broken") if !@healthy
    end

  end

end
