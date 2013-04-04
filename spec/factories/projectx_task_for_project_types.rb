# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_for_project_type, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 1
    type_definition_id 1
    last_updated_by_id 1
    execution_order 1
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a2, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 2
    type_definition_id 1
    last_updated_by_id 1
    execution_order 1
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a3, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 3
    type_definition_id 1
    last_updated_by_id 1
    execution_order 2
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a4, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 4
    type_definition_id 1
    last_updated_by_id 1
    execution_order 3
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a5, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 5
    type_definition_id 1
    last_updated_by_id 1
    execution_order 4
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a6, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 6
    type_definition_id 1
    last_updated_by_id 1
    execution_order 5
    execution_sub_order 1
    start_before_previous_completed false
  end

  factory :task_for_project_type_a7, :class => 'Projectx::TaskForProjectType' do
    task_definition_id 7
    type_definition_id 1
    last_updated_by_id 1
    execution_order 6
    execution_sub_order 1
    start_before_previous_completed false
  end


end
