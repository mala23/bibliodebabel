env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bibliodebabel_#{env}")

require './app/models/link'
require './app/models/user'

DataMapper.finalize

DataMapper.auto_upgrade!