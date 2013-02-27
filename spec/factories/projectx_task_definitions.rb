# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_definition, :class => 'Projectx::TaskDefinition' do
    name "MyString task"
    task_desp "MyString task desp"
    task_instruction "MyText how to do task"
    last_updated_by_id 1
    ranking_order 1
    active true
  end
end
