# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_definition, :class => 'Projectx::TaskDefinition' do
    name "MyString task"
    task_desp "MyString task desp"
    task_instruction "MyText how to do task"
    last_updated_by_id 1
    ranking_order 1
    active true
  end

  factory :task_definition_create_doc, :class => 'Projectx::TaskDefinition' do
    name "Create Document"
    task_desp "Create Document"
    task_instruction "Please Create Document this is how"
    last_updated_by_id 1
    ranking_order 1
    active true
  end

  factory :task_definition_fill_doc, :class => 'Projectx::TaskDefinition' do
    name "Fill Document"
    task_desp "Fill Document"
    task_instruction "Please Fill Document this is how"
    last_updated_by_id 1
    ranking_order 2
    active true
  end

  factory :task_definition_review_doc, :class => 'Projectx::TaskDefinition' do
    name "Review Document"
    task_desp "Review Document"
    task_instruction "Please Review Document this is how"
    last_updated_by_id 1
    ranking_order 3
    active true
  end

  factory :task_definition_audit_doc, :class => 'Projectx::TaskDefinition' do
    name "Audit Document"
    task_desp "Audit Document"
    task_instruction "Please Review Document this is how"
    last_updated_by_id 1
    ranking_order 4
    active true
  end

  factory :task_definition_print_doc, :class => 'Projectx::TaskDefinition' do
    name "Print Document"
    task_desp "Print Document"
    task_instruction "Please Print Document this is how"
    last_updated_by_id 1
    ranking_order 5
    active true
  end

  factory :task_definition_bind_doc, :class => 'Projectx::TaskDefinition' do
    name "Bind Document"
    task_desp "Bind Document"
    task_instruction "Please Bind Document this is how"
    last_updated_by_id 1
    ranking_order 6
    active true
  end

end
