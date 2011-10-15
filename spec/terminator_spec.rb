require File.expand_path('../spec_helper', __FILE__)
require 'rbconfig'

describe Consular::Terminator do
  it 'should be added as a core to Consular' do
    Consular.cores.should include Consular::Terminator
  end

  it 'should treat linux as a valid system' do
    RbConfig::CONFIG.expects(:[]).with('host_os').returns('x86-linux')
    Consular::Terminator.expects(:`).with('which xdotool').returns('/usr/bin/xdotool')
    stat = mock()
    stat.expects(:executable?).returns(true)
    File::Stat.expects(:new).returns(stat)
    Consular::Terminator.valid_system?.should == true
  end

  it 'should treat non-linux as an invalid system' do
    RbConfig::CONFIG.expects(:[]).with('host_os').returns('darwin')
    Consular::Terminator.valid_system?.should == false
  end

  it 'should treat systems without "which" as invalid' do
    RbConfig::CONFIG.expects(:[]).with('host_os').returns('x86-linux')
    Consular::Terminator.expects(:`).with('which xdotool').returns('which: command not found')
    File::Stat.expects(:new).throws('no such file')
    Consular::Terminator.valid_system?.should == false
  end

  it 'should treat systems without "xdotool" as invalid' do
    RbConfig::CONFIG.expects(:[]).with('host_os').returns('x86-linux')
    Consular::Terminator.expects(:`).with('which xdotool').returns('')
    File::Stat.expects(:new).throws('no such file')
    Consular::Terminator.valid_system?.should == false
  end

  it 'should send ctrl+shift+i when creating new window' do
    core = Consular::Terminator.new ''
    core.expects(:active_terminator_window).returns(1)
    core.expects(:xdotool).with("key --window 1 ctrl+shift+i")
    core.open_window
  end

  it 'should send ctrl+shift+t when creating new tab' do
    core = Consular::Terminator.new ''
    core.expects(:active_terminator_window).returns(1)
    core.expects(:xdotool).with("key --window 1 ctrl+shift+t")
    core.open_tab
  end
end
