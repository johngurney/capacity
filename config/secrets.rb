# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rails secret` to generate a secure secret key.

# Make sure the secrets in this file are kept private
# if you're sharing your code publicly.

development:
  secret_key_base: 852ec70977d8a1e41119ee3d7ea59a50228401d2a3aa3fd23a706b306275f47a213cd6e6d1a3840c5329adbbeeb3bdb7bc0779295e24b87fc4eb56784de81e18

test:
  secret_key_base: aaa7f0a0b9b365085e890952fddcf99cbcaf64c2d37688b07c78fc77b99736321ad36f83f547de486d58241a47e6c60bf10fd856c1794de10895e54c49e5abff

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: aeefd805fc2bf612bc322260d21725acc28ba5614d6e0608dfae86fd037473eb539cc46512cc8bcd6e1a5aec2c5b5c0417a538ad227454dc7776de8cac23477b
