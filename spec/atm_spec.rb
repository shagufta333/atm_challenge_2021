require "./lib/atm.rb"

describe Atm do
  subject { Atm.new }
  let (:account) {
    instance_double("Account", pin_code: "1234",
    exp_date: "04/40", account_status: :active)
  }

  before do
    allow(account).to receive(:balance).and_return(100)
    allow(account).to receive(:balance=)
  end
  it "is expected to hold $1000 when instantiated" 
    expect(subject.funds).to eq 1000
  end
  it "is expected to reduce funds on withdraw" do
    subject.withdraw 50, "1234", account
    expect(subject.funds).to eq 950
  end
  it "is expected to allow withdrawal if account has enough balance" do
    expected_output = {
      status: true,
      message: "success",
      date: Date.today,
      amount: 45,
      bills: [20, 20, 5],
    }
    expect(subject.withdraw(45, "1234", account)).to eq expected_output
  end

  it "is expected to reject an withdrawal if account has insufficient funds" do
    expected_output = {
      status: false,
      message: "insufficient funds",
      date: Date.today,
    }
    expect(subject.withdraw(105, "1234", account)).to eq expected_output
  end
  it "reject withdraw if atm has insufficient funds" do
    subject.funds = 50
    expected_output = {
      status: false,
      message: "insufficient funds in atm",
      date: Date.today,
    }
    expect(subject.withdraw(100, "1234", account)).to eq expected_output
  end
  it "reject withdraw if the pin is wrong" do
    expected_output = {
      status: false,
      message: "wrong pin",
      date: Date.today,
    }
    expect(subject.withdraw(50, 9999, account)).to eq expected_output
  end
  it "reject withdraw if the card is expired" do
    allow(account).to receive(:exp_date).and_return("12/15")
    expected_output = {
      status: false,
      message: "card expired",
      date: Date.today,
    }
    expect(subject.withdraw(6, "1234", account)).to eq expected_output
  end
  it "is expected to reject if account is disabled" do
    allow(account).to receive(:account_status).and_return(:deactivated)
    expected_output = {
      status: false,
      message: "account disabled",
      date: Date.today,
    }
    expect(subject.withdraw(6, "1234", account)).to eq expected_output
  end
end
