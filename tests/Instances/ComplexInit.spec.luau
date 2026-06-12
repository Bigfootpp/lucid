--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function()

	local Config = class() {
		host = "localhost",
		port = 8080,
		timeout = 5000,
		ssl = false,
	} {}

	local Database = class(Config) {
		name = "default",
		poolSize = 10,
	} {
		__init = function(self, name: string, opts: {poolSize: number?, ssl: boolean?}?)
			self.name = name
			self.poolSize = opts and opts.poolSize or 10
			self.ssl = opts and opts.ssl or false
		end,
		connect = function(self)
			return ("Connecting to %s:%d (%s)"):format(self.host, self.port, self.name)
		end,
	}

	local db = Database:create("users", { poolSize = 20, ssl = true })
	assert(db.host == "localhost", "Inherited host")
	assert(db.port == 8080, "Inherited port")
	assert(db.timeout == 5000, "Inherited timeout")
	assert(db.name == "users", "Own name")
	assert(db.poolSize == 20, "Own poolSize from opts")
	assert(db.ssl == true, "Own ssl from opts")
	assert(db:connect() == "Connecting to localhost:8080 (users)", "Method uses inherited + own")

end