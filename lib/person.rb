require "./lib/account.rb"

class Person
  attr_accessor :name, :cash, :account

  def initialize(args = {})
    @name = set_name(args[:name])
    @cash = 0
    @account = nil
  end

  def create_account
    @account = Account.new({ owner: self.name })
  end

  def deposit(amount)
    @account == nil ? missing_account : deposit_funds(amount)
  end

  def withdraw(args = {})
    @account == nil ? missing_account : withdraw_funds(args)
  end

  private

  def deposit_funds(amount)
    @account.balance += amount
    @cash -= amount
  end

  def withdraw_funds(args)
    args[:atm] == nil ? missing_atm : atm = args[:atm]
    account = @account
    amount = args[:amount]
    pin = args[:pin]
    response = atm.withdraw(amount, pin, account)
    response[:status] == true ? add_cash(response) : response
  end

  def add_cash(response)
    @cash += response[:amount]
  end

  def set_name(name)
    name == nil ? missing_name : name
  end

  def missing_name
    raise ArgumentError, "A name is required"
  end

  def missing_account
    raise RuntimeError, "No account present"
  end

  def missing_atm
    raise RuntimeError, "An ATM is required"
  end
end
