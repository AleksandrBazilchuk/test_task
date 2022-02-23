FactoryBot.define do
  factory :building do
    address { 'Address 1' }
    zip_code { '75000' }
    city { 'Paris' }
    country { 'France' }
    manager_name { 'Manager Name' }
  end

  factory :person do
    email { 'test_mail@mail.com' }
    home_phone_number { '+331234567' }
    mobile_phone_number { '+331234567' }
    firstname { 'test_first_name' }
    lastname { 'test_last_name' }
    address { 'Address 1' }
  end

  factory :field_change_history do
    association :source
  end
end
