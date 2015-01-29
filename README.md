# Certmeister

Certmeister is a conditionally autosigning Certificate Authority. It was developed for use
with the Puppet infrastructure at Hetzner PTY Ltd.

The service will autosign a certificate request when the configurable access policy permits.
The reference access policy in use by Hetzner PTY Ltd is:

* the Common Name (CN) of the certificate is in the host-h.net domain,
* the service has no record of already having signed a certificate for that CN, and
* the requesting client IP address has forward confirmed reverse DNS that matches the CN.
* Requests to fetch certificates are always allowed.
* Requests to delete certificates are only allowed when they originate from
  a secure operator network.

This allows us the convenience of Puppet's autosign feature, without the horrendous security implications.

This repository currently builds two gems:

* _certmeister_ - the CA, some off-the-shelf policy modules and an in-memory cert store
* _certmeister-rack_ - a rack application to provide an HTTP interface to the CA

Only an in-memory store is provided. Others are available as separate gems:

* [certmeister-dynamodb](https://github.com/sheldonh/certmeister-dynamodb)
* [certmeister-pg](https://github.com/sheldonh/certmeister-pg)
* [certmeister-redis](https://github.com/sheldonh/certmeister-redis)

An example, using redis and rack and enforcing Hetzner PTY Ltd's policy, is available in [contrib/config.ru](contrib/config.ru).

To hit the service:

```
$ curl -L \
    -d "psk=secretkey" \
    -d "csr=$(perl -MURI::Escape -e 'print uri_escape(join("", <STDIN>));' < fixtures/client.csr)" \
    http://localhost:9292/ca/certificate/axl.starjuice.net
```

## Testing

```
rake spec
```

## Releasing

If you work at Hetzner and need to release new versions of the gems, do this
(obviously only after making sure the tests run and you have no uncommitted
changes):

```
# edit lib/certmeister/version.rb
bundle
git commit \
  -m "Bump version to v$(bundle exec ruby -Ilib -rcertmeister -e 'puts Certmeister::VERSION')" \
  Gemfile.lock lib/certmeister/version.rb
bundle exec rake release
```
