# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_template, :class => 'Projectx::TaskTemplate' do
    project_template_id 1
    task_definition_id 1
    execution_order 1
    execution_sub_order 1
    start_before_previous_completed false
    brief_note "MyText"
    need_request false
  end
end
