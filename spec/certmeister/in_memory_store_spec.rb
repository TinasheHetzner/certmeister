require 'spec_helper'

require 'certmeister/in_memory_store'

describe Certmeister::InMemoryStore do

  it "accepts initialization options" do
    expect {Certmeister::InMemoryStore.new({}) }.to_not raise_error
  end

  it "stores certificates by CN (common name)" do
    pem = File.read('fixtures/client.crt')
    subject.store('axl.hetzner.africa', pem)
    expect(subject.fetch('axl.hetzner.africa')).to eql pem
  end

  it "returns nil when fetching non-existent CN" do
    expect(subject.fetch('axl.hetzner.africa')).to be_nil
  end

  it "is not concerned with validating certificates" do
    expect { subject.store('axl.hetzner.africa', "nonsense") }.to_not raise_error
  end

  it "overwrites an existing certificate if one exists" do
    subject.store('axl.hetzner.africa', "first")
    subject.store('axl.hetzner.africa', "second")
    expect(subject.fetch('axl.hetzner.africa')).to eql "second"
  end

  it "returns true from health_check when healthy" do
    expect(subject.health_check).to be_true
  end

  it "returns false from health_check when not healthy" do
    subject.send(:break!)
    expect(subject.health_check).to be_false
  end

end
