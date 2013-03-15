# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status_definition, :class => 'Projectx::StatusDefinition' do
    name "MyString status"
    brief_note "MyString some note"
    last_updated_by_id 1
    for_what "task"
    ranking_order 1
    active true
  end

  factory :status_definition_new, :class => 'Projectx::StatusDefinition' do
    name "New"
    brief_note "New"
    last_updated_by_id 1
    for_what "project"
    ranking_order 1
    active true
  end

  factory :status_definition_started, :class => 'Projectx::StatusDefinition' do
    name "Started"
    brief_note "Started"
    last_updated_by_id 1
    for_what "task"
    ranking_order 1
    active true
  end

  factory :status_definition_in_progress, :class => 'Projectx::StatusDefinition' do
    name "in Progress"
    brief_note "in Progress"
    last_updated_by_id 1
    for_what "task"
    ranking_order 2
    active true
  end

  factory :status_definition_cxl, :class => 'Projectx::StatusDefinition' do
    name "Cancelled"
    brief_note "Cancelled"
    last_updated_by_id 1
    for_what "task"
    ranking_order 3
    active true
  end

  factory :status_definition_on_hold, :class => 'Projectx::StatusDefinition' do
    name "On Hold"
    brief_note "On Hold"
    last_updated_by_id 1
    for_what "task"
    ranking_order 4
    active true
  end

  factory :status_definition_completed, :class => 'Projectx::StatusDefinition' do
    name "Completed"
    brief_note "Completed"
    last_updated_by_id 1
    for_what "task"
    ranking_order 5
    active true
  end

end
