# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project1, :class => 'Projectx::Project' do
    name "water inspection"
    project_num "201323123"
    customer_id 1
    project_type_id 1
    zone_id 1
    project_desp "this is the desp of the project"
    sales_id 1
    start_date "2013-02-25"
    end_date "2013-02-25"
    delivery_date "2013-02-25"
    project_instruction "1. start machine, 2. turn knob"
    project_manager_id 1
    cancelled false
    completed false
    last_updated_by_id 1
  end

  factory :project2, :class => 'Projectx::Project' do
    name "water inspection2"
    project_num "301323125"
    customer_id 1
    project_type_id 1
    zone_id 1
    project_desp "this is the desp of the project"
    sales_id 1
    start_date "2013-02-25"
    end_date "2013-02-25"
    delivery_date "2013-02-25"
    project_instruction "1. start machine, 2. turn knob"
    project_manager_id 1
    cancelled false
    completed false
    last_updated_by_id 1
  end

  factory :project3, :class => 'Projectx::Project' do
    name "water inspection3"
    project_num "401323123"
    customer_id 1
    project_type_id 1
    zone_id 1
    project_desp "this is the desp of the project"
    sales_id 1
    start_date "2013-02-25"
    end_date "2013-02-25"
    delivery_date "2013-02-25"
    project_instruction "1. start machine, 2. turn knob"
    project_manager_id 1
    cancelled false
    completed false
    last_updated_by_id 1
  end


end
