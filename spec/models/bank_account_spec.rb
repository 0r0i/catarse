require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:custom_bank) { create(:bank, code: "00M")}
  let(:bank_account) { create(:bank_account) }

  describe "associations" do
    it{ is_expected.to belong_to :user }
  end

  describe "Validations" do
    it{ is_expected.to validate_presence_of(:bank_id) }
    it{ is_expected.to validate_presence_of(:agency) }
    it{ is_expected.to validate_presence_of(:account) }
    it{ is_expected.to validate_presence_of(:account_digit) }
    it{ is_expected.to validate_presence_of(:owner_name) }
    it{ is_expected.to validate_presence_of(:owner_document) }
  end

  describe "#complete_agency_string" do
    subject { bank_account.complete_agency_string }
    context "without a agency digit" do
      before do
        bank_account.update_column(:agency_digit, nil)
      end

      it { is_expected.to eq("#{bank_account.agency}") }
    end

    context "with agency digit" do
      it { is_expected.to eq("#{bank_account.agency} - #{bank_account.agency_digit}") }
    end
  end

  describe "#complete_account_string" do
    subject { bank_account.complete_account_string }
    it { is_expected.to eq("#{bank_account.account} - #{bank_account.account_digit}") }
  end

  describe "#input_bank_number_validation" do
    before do
      custom_bank
    end

    context "when input_bank_number has a invalid bank number" do
      before do
        bank_account.input_bank_number = "009123"
      end

      it { expect(bank_account.valid?).to be_falsey }
    end

    context "when input_bank_number has a valid bank" do
      before do
        bank_account.input_bank_number = "00M"
      end
      it { is_expected.to be_truthy }
    end
  end
end
