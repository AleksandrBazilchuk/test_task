class Building < ApplicationRecord
  has_many :field_change_histories, as: :source, dependent: :destroy

  def self.high_level_fields
    %w[manager_name]
  end
end
