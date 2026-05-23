local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestScripts = ReplicatedStorage.Tests:GetChildren()

for _, testScript in TestScripts do
    pcall(function()
        require(testScript)()
    end)
end