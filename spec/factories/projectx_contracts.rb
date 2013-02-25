# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contract, :class => 'Projectx::Contract' do
    project_id 1
    contract_total "9.99"
    other_charge "9.99"
    payment_term "MyString"
    paid_out false
    contract_signed false
    sign_date "2013-02-25"
    contract_on_file false
  end
end
