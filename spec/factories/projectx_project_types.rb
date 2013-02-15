# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_type, :class => 'Projectx::ProjectType' do
    name "project type"
    last_updated_by_id 1
    active true
    brief_note "for types"
  end
end
