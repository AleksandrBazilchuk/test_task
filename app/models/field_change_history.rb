class FieldChangeHistory < ApplicationRecord
  belongs_to :source, polymorphic: true
end
