require File.expand_path('../spec_helper', __FILE__)
require 'rbconfig'

describe Consular::Terminator do
  it 'should be added as a core to Consular' do
    Consular.cores.should include Consular::Terminator
  end

  it 'should treat linux as a valid system' do
    RbConfig::CONFIG.expects(:[]).returns({ 'host_os' => 'x86-linux' })
    Consular::Terminator.valid_system?.should == true
  end

  it 'should treat non-linux as an invalid system' do
    RbConfig::CONFIG.expects(:[]).with('host_os').returns('darwin')
    Consular::Terminator.valid_system?.should == false
  end

  it 'should treat systems without "which" as invalid' do
    RbConfig::CONFIG.expects(:[]).returns({ 'host_os' => 'x86-linux' })
    Kernel.expects(:`).with('which xdotool').returns('which: command not found')
    Consular::Terminator.valid_system?.should == false
  end
end
