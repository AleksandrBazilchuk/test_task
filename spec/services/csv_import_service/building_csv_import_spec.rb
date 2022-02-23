require 'rails_helper'

describe CsvImportService::BuildingCsvImport do
  subject { described_class.new }

  describe '#result' do
    let(:path) { "#{Rails.root}/spec/services/csv_import_service/content/buildings.csv" }

    let!(:first_record) { create(:building, reference: '3') }
    let!(:second_record) { create(:building, address: 'Address 2', reference: '4') }

    context 'when users references does not match to references from csv' do
      it 'does not update users' do
        subject.perform(path)

        expect(Building.all.as_json(only: %i[address reference])).to eq(
          [{ 'address' => 'Address 1', 'reference' => '3' }, { 'address' => 'Address 2', 'reference' => '4' }]
        )
      end
    end

    context 'when users are found by the references' do
      before do
        first_record.update(reference: '1')
        second_record.update(reference: '2')
      end

      it 'updates these users' do
        subject.perform(path)

        expect(Building.all.reload.as_json(except: %i[id created_at updated_at])).to eq(
          [
            {
              'address' => '10 Rue La bruyère',
              'zip_code' => '75009',
              'city' => 'Paris',
              'country' => 'France',
              'manager_name' => 'Martin Faure',
              'reference' => '1'
            },
            {
              'address' => '40 Rue René Clair',
              'zip_code' => '75018',
              'city' => 'Paris',
              'country' => 'France',
              'manager_name' => 'Martin Faure',
              'reference' => '2'
            }
          ]
        )
      end
    end

    context 'when some fields have already been changed' do
      before do
        first_record.update(reference: '1')

        create(:field_change_history, source: first_record, field_name: 'manager_name', value: 'Martin Faure')
      end

      it 'does not update these fields' do
        subject.perform(path)

        expect(first_record.reload.as_json(only: %i[address manager_name])).to eq(
          { 'address' => '10 Rue La bruyère', 'manager_name' => 'Manager Name' }
        )
      end
    end
  end
end
