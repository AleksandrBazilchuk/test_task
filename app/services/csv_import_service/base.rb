# frozen_string_literal: true

require 'csv'

module CsvImportService
  class Base
    def perform(path)
      CSV.foreach(path, headers: true).each do |row|
        record = @collection.find_by(reference: row['reference'])
        next if record.nil?

        row.headers.each do |field_name|
          field_value = row[field_name]
          next unless can_field_be_updated?(field_name, field_value, record)

          record[field_name] = field_value
        end

        record.save
      end
    end

    private

    def can_field_be_updated?(field_name, field_value, record)
      return true unless field_name.in?(high_level_fields)

      last_values = record.field_change_histories.where(field_name: field_name).pluck(:value)
      return false if field_value.in?(last_values)

      true
    end
  end
end
