# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_for_project_type, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 1
    project_type_id 1
    last_updated_by_id 1
    execution_order 1
    execution_sub_order 1
    start_before_previous_completed false
  end
end
