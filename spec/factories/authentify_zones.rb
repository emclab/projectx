# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zone, :class => 'Authentify::Zone' do
    zone_name "hq"
    brief_note "zone hq"
    active true
    ranking_order 1
  end

  factory :zone1, :class => 'Authentify::Zone' do
    zone_name "xxq"
    brief_note "zone xx"
    active true
    ranking_order 2
  end

end
