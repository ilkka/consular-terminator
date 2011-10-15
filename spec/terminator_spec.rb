require File.expand_path('../spec_helper', __FILE__)

describe Consular::Terminator do
  it 'should be added as a core to Consular' do
    Consular.cores.should_include Consular::Terminator
  end
end
