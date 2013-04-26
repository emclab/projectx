# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projectx_payment, :class => 'Projectx::Payment' do
    paid_amount 1.5
    received_date "2013-04-24"
    received_by "MyString"
  end
end
