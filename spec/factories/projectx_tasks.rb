# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task, :class => 'Projectx::Task' do
    project_id 1
    brief_note "MyText"
    assigned_to_id 1
    cancelled false
    completed false
    expedite false
    skipped false
    finish_date "2013-04-16"
    start_date "2013-04-16"
    task_status_definition_id 1
    task_definition_id 1
    last_updated_by_id 1
  end
end
