require "./lib/person.rb"
require "./lib/atm.rb"

describe Person do
  subject { described_class.new(name: "Shagufta") }

  it "is expected to have a :name on initialize" do
    expect(subject.name).not_to be nil
    expect(subject.name).to eq "Shagufta"
  end

  it "is expected to raise an error if no name is set" do
    expect { described_class.new }.to raise_error "A name is required"
  end

  it "is expected to have a :cash attribute with the value of 0 on initialize" do
    expect(subject.cash).to eq 0
  end

  it "is expected to have a :account attribute" do
    expect(subject.account).to be nil
  end

  describe "can create an Account" do
    before { subject.create_account }

    it "is expected to be an instance of Account class" do
      expect(subject.account).to be_an_instance_of Account
    end

    it "is expected to have an account with herself as an owner" do
      expect(subject.account.owner).to be subject.name
    end
  end

  describe "can manage funds if an account has been created" do
    let(:atm) { Atm.new }
    # As a Person with a bank account,
    # in order to be able to put my funds in the account,
    # I would like to be able to make a deposit
    before { subject.create_account }

    it "is expected to be able to deposit funds" do
      expect(subject.account.balance).to eq 0
      expect(subject.deposit(100)).to be_truthy
      expect(subject.account.balance).to eq 100
    end
  end
  describe "can manage funds if an account has been created" do
    let(:atm) { Atm.new }
    before { subject.create_account }

    it "is expected to add funds to the account balance - deducted from cash" do
      # As a person depositing cash is suposed to have the cash availible
      # The bank account is suposed to obtain that money on the balance
      # and at the same time, be removed from the person's access to cash
      subject.cash = 100
      subject.deposit(100)
      expect(subject.account.balance).to be 100
      expect(subject.cash).to be 0
    end
    it "is expected to to withdraw funds" do
      subject.account.balance = 500
      command = lambda { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account, atm: atm) }
      expect(command.call).to be_truthy
    end
    it "is expected to raise an error if no ATM is passed in " do
      command = lambda { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account) }
      expect { command.call }.to raise_error "An ATM is required"
    end
    it "can add funds to cash and deduct from the account balance " do
      subject.cash = 100
      subject.deposit(100)
      subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account, atm: atm)
      expect(subject.account.balance).to be 0
      expect(subject.cash).to be 100
    end
  end

  describe "can not manage funds if no account has been created" do
    # As a Person without a bank account,
    # In order to prevent me from using the wrong bank account,
    # It should NOT be able to make a deposit.

    it "is expected to NOT being able to deposit funds" do
      expect { subject.deposit(100) }.to raise_error(RuntimeError, "No account present")
    end
  end
end
