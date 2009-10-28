# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_restfulie-test_session',
  :secret      => '9a46532188f101a8cdc7255705ce9771f401c8966c00b2f7251e0c9fa84bf3f60ac66da7c8c066ab4318d753b189ddecd1b52584027610f5b8d64f3c1b4c77ba'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
