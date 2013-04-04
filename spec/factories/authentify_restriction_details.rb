# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restriction_detail, :class => 'Authentify::RestrictionDetail' do
    user_access_id 1
    match_against "sales_id"
    restriction_type "user"
    brief_note "my note"
  end
end
