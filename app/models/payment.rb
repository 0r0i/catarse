class Payment < ActiveRecord::Base
  include Shared::StateMachineHelpers

  has_and_belongs_to_many :contributions

  validates_presence_of :state, :key, :gateway, :method, :value, :installments, :installment_value

  before_validation do
    self.key ||= SecureRandom.uuid
  end

  def contribution
    contributions.first
  end
  state_machine :state, initial: :pending do
  end
end
