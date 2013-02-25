# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_execution, :class => 'Projectx::TaskExecution' do
    project_id 1
    task_definition_id 1
    expedite false
    expedite_finish_date "2013-02-25"
    last_updated_by_id 1
    brief_note "MyString"
    cancelled false
    completed false
    skipped false
    started false
    start_date "2013-02-25"
    end_date "2013-02-25"
    status_id 1
    assigned_to_id 1
  end
end
