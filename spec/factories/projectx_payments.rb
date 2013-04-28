# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment, :class => 'Projectx::Payment' do
    paid_amount 1.5
    received_date "2013-04-24"
    received_by_id 1
    contract_id 1
    payment_type 'wire'
  end
end
