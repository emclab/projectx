# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer, :class => 'Customerx::Customer' do
    name "Customer1"
    short_name "Customer1"
    since_date "2013-01-12"
    shipping_instruction "Myshipping"
    zone_id 1
    customer_status_category_id 1
    phone "1234"
    fax "fax2344"
    sales_id 1
    active true
    last_updated_by_id 1
    quality_system_id 1
    employee_num "4"
    revenue "100,000"
    customer_eval "MyText"
    main_biz "MyText"
    customer_taste "A good guy"
    note "My note"
  end

  factory :customer2, :class => 'Customerx::Customer' do
    name "Customer2"
    short_name "Customer2"
    since_date "2013-01-12"
    shipping_instruction "Myshipping"
    zone_id 1
    customer_status_category_id 1
    phone "1234"
    fax "fax2344"
    sales_id 1
    active true
    last_updated_by_id 1
    quality_system_id 1
    employee_num "4"
    revenue "100,000"
    customer_eval "MyText"
    main_biz "MyText"
    customer_taste "A good guy"
    note "My note"
  end


end
