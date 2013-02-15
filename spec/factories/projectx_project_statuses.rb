# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_status, :class => 'Projectx::ProjectStatus' do
    name "in progress"
    brief_note "project in progress"
    active true
    last_updated_by_id 1
    ranking_order 1
  end
end
