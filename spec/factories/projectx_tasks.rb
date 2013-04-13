# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task, :class => 'Projectx::Task' do
    project_id 1
    task_definition_id 1
    status_definition_id 1
    expedite false
    last_updated_by_id 1
    brief_note "MyText"
    start_date "2013-04-11"
    finish_date "2013-04-11"
    assigned_to_id 1
    cancelled false
    skipped false
    completed false
  end
end
