# encoding: utf-8

FactoryGirl.define do

  factory :engine_config, :class => 'Authentify::EngineConfig' do
    engine_name     nil
    engine_version  nil
    argument_name   "Pagination"
    argument_value  30
  end
  
end

