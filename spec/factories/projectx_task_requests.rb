# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_request, :class => 'Projectx::TaskRequest' do
    name 'printing a copy'
    task_id 1
    request_date "2013-04-12"
    expedite false
    expected_finish_date "2013-04-12"
    request_content "MyText"
    need_delivery false
    what_to_deliver "MyText"
    delivery_instruction "MyString"
    completed false
    cancelled  false
    last_updated_by_id 1
    requested_by_id 1
  end
end
