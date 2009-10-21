# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_touhou-shop_session',
  :secret      => 'a2197b05ada61d6f0d448f3d637e2c51349e2067686ac7e54972f0859deac2d231a01b53504cbdb4ac64caa9885b66c2492f90eae3477c4ae5627cc84eee3e01'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
