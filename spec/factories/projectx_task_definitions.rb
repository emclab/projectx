# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_definition, :class => 'Projectx::TaskDefinition' do
    name "MyString"
    task_desp "MyString"
    task_instruction "MyText"
    last_updated_by_id 1
    ranking_order 1
  end
end
