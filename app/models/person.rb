class Person < ApplicationRecord
  has_many :field_change_histories, as: :source, dependent: :destroy

  def self.high_level_fields
    %w[email mobile_phone_number home_phone_number address]
  end
end
