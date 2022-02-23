module CsvImportService
  class BuildingCsvImport < CsvImportService::Base
    def initialize
      @collection = Building.all
    end

    private

    def high_level_fields
      Building.high_level_fields
    end
  end
end
