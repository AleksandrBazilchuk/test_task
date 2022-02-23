module CsvImportService
  class PersonCsvImport < CsvImportService::Base
    def initialize
      @collection = Person.all
    end

    private

    def high_level_fields
      Person.high_level_fields
    end
  end
end
