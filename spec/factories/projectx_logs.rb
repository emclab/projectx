# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log, :class => 'Projectx::Log' do
    task_id 1
    task_request_id 1
    log "MyText"
    last_updated_by_id 1
   
  end
end
