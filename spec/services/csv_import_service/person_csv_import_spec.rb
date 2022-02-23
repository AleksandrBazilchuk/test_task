require 'rails_helper'

describe CsvImportService::PersonCsvImport do
  subject { described_class.new }

  describe '#result' do
    let(:path) { "#{Rails.root}/spec/services/csv_import_service/content/people.csv" }

    let!(:first_record) { create(:person, firstname: 'first_person', reference: '3') }
    let!(:second_record) { create(:person, firstname: 'second_person', reference: '4') }

    context 'when users references does not match to references from csv' do
      it 'does not update users' do
        subject.perform(path)

        expect(Person.all.as_json(only: %i[firstname reference])).to eq(
          [
            { 'firstname' => 'first_person', 'reference' => '3' },
            { 'firstname' => 'second_person', 'reference' => '4' }
          ]
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

        expect(Person.all.reload.as_json(except: %i[id created_at updated_at])).to eq(
          [
            {
              'firstname' => 'Henri',
              'lastname' => 'Dupont',
              'home_phone_number' => '0123456789',
              'mobile_phone_number' => '0623456789',
              'email' => 'h.dupont@gmail.com',
              'address' => '10 Rue La bruyère',
              'reference' => '1'
            },
            {
              'firstname' => 'Jean',
              'lastname' => 'Durand',
              'home_phone_number' => '0123336789',
              'mobile_phone_number' => '0663456789',
              'email' => 'jdurand@gmail.com',
              'address' => '40 Rue René Clair',
              'reference' => '2'
            }
          ]
        )
      end
    end

    context 'when some fields have already been changed' do
      before do
        first_record.update(reference: '1')

        create(:field_change_history, source: first_record, field_name: 'address', value: '10 Rue La bruyère')
      end

      it 'does not update these fields' do
        subject.perform(path)

        expect(first_record.reload.as_json(only: %i[firstname lastname address])).to eq(
          { 'firstname' => 'Henri', 'lastname' => 'Dupont', 'address' => 'Address 1' }
        )
      end
    end
  end
end
