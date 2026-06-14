--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local class = require(ReplicatedStorage.Packages.LuCid)

return function(): boolean | string

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
	if not (db.host == "localhost") then return "Inherited host" end
	if not (db.port == 8080) then return "Inherited port" end
	if not (db.timeout == 5000) then return "Inherited timeout" end
	if not (db.name == "users") then return "Own name" end
	if not (db.poolSize == 20) then return "Own poolSize from opts" end
	if not (db.ssl == true) then return "Own ssl from opts" end
	if not (db:connect() == "Connecting to localhost:8080 (users)") then return "Method uses inherited + own" end

	return true
end