# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contract, :class => 'Projectx::Contract' do
    project_id 1
    contract_amount "9.99"
    other_charge "9.99"
    payment_term 10
    paid_out false
    signed false
    sign_date "2013-02-25"
    contract_on_file false
    last_updated_by_id 1
    payment_agreement 'some agreement'
    signed_by_id '1'
  end
end
