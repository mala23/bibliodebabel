require 'bcrypt'
# Use bcrypt to generate password hashes

class User

	include DataMapper::Resource

	property :id,    Serial
	property :email, String, :unique => true, :message => "This email address is already signed up"

	property :password_digest, Text

	attr_reader :password
	attr_accessor :password_confirmation

	# validates_uniqueness_of :email

	validates_confirmation_of :password
	# this is datamapper's method of validating the model.
	# The model will not be saved unless both password
	# and password_confirmation are the same
	# read more about it in the documentation
	# http://datamapper.org/docs/validations.html

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
			# return this user
		else
			nil
		end
	end

end