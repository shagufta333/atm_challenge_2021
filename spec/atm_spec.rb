
require './lib/atm.rb'

describe Atm do
    subject {Atm.new}
    it 'is expected to hold $1000 when instantiated' do
     expect(subject.funds).to eq 1000
end
end
