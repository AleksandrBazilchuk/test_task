In this test task, a service was implemented that imports data from a CSV file and updates records from a database.

This service module is located in the _app/services_ directory and is named `CsvImportService`.

A new `field_change_histories` table has been created to store previous changes to some of the records.
This table is polymorphic. Therefore, it will be convenient to associate it with any new model.

The algorithm works on each record from the database to check for fields that have been updated.
And the `reference` fields were taken as a unique identifier. Therefore, to improve performance for each query,
an index was added on the `reference` columns.

`RSpec` was used to write new tests. The tests use sample files from the task condition.
The `FactoryBot` gem was used to create the test entries.
