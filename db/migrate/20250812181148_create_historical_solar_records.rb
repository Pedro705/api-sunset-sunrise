class CreateHistoricalSolarRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :historical_solar_records do |t|
      # Each historical record must be associated to a location
      t.references :location, null: false, foreign_key: true

      t.date :date, null: false
      t.datetime :sunrise
      t.datetime :sunset
      t.datetime :first_light
      t.datetime :last_light
      t.datetime :dawn
      t.datetime :dusk
      t.datetime :solar_noon
      t.datetime :golden_hour
      t.integer :day_length # in seconds
      t.string :timezone
      t.integer :utc_offset

      t.timestamps
    end

    # Ensure we can not have duplicate records for the same location-date combination
    add_index :historical_solar_records, [ :location_id, :date ], unique: true
    # Performance improvement when querying by date
    add_index :historical_solar_records, :date
  end
end
