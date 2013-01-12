ActiveRecord::Base.configurations[:development] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :database  => 'robbin_site',
  :pool      => 5,
  :username  => 'root',
  :password  => 'fankai',
  :host      => 'localhost',
  :socket    => '/tmp/mysql.sock'

}

ActiveRecord::Base.configurations[:production] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :database  => 'robbin_site',
  :pool      => 5,
  :username  => 'root',
  :password  => 'fankai',
  :host      => 'localhost',
  :socket    => '/tmp/mysql.sock'

}

ActiveRecord::Base.configurations[:test] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :database  => 'robbin_site_test',
  :pool      => 5,
  :username  => 'root',
  :password  => 'fankai',
  :host      => 'localhost',
  :socket    => '/tmp/mysql.sock'

}

# Setup our logger
ActiveRecord::Base.logger = logger

# Raise exception on mass assignment protection for Active Record models.
ActiveRecord::Base.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL).
ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Set timezone to local
ActiveRecord::Base.default_timezone = :local
ActiveRecord::Base.time_zone_aware_attributes = false

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])
