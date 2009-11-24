# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_valet_session',
  :secret      => '2dbd9e8faa81e6e6818e1120dbeaaa730f7181efc19de20db9507a7555b4089ac637c8fb036380e429042bc7d65b81f8e8b06504afd6cc65739a0f41613c9c26'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
