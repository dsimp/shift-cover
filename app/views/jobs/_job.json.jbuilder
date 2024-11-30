json.extract! job, :id, :shift_date, :opener_id, :cover_id, :location_name, :shift_started_at, :shift_ended_at, :location_address, :title, :description, :job_type_id, :created_at, :updated_at
json.url job_url(job, format: :json)
