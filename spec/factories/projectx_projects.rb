# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project, :class => 'Projectx::Project' do
    name "water inspection"
    project_num "201323123"
    customer_id 1
    type_id 1
    project_desp "this is the desp of the project"
    sales_id 1
    start_date "2013-02-25"
    end_date "2013-02-25"
    delivery_date "2013-02-25"
    project_instruction "1. start machine, 2. turn knob"
    project_manager_id 1
    cancelled false
    completed false
  end
end
