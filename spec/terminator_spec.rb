require File.expand_path('../spec_helper', __FILE__)
require 'rbconfig'

describe Consular::Terminator do
  it 'should be added as a core to Consular' do
    Consular.cores.should include Consular::Terminator
  end

  it `should treat linux as a valid system` do
    RbConfig::CONFIG.any_instance.expects(:[]).with('host_os').returns('x86-linux')
    Consular::Terminator.valid_system?.should be true
  end
end
