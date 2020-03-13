-- twitch channel to request viewers from
local channel = "chasingcarrots"
-- update viewers every 5 minutes
local update_frequency = 5

local http = require("http")
local json = require("json")

local viewers = {}
local applicants = {}
local employees = {}

-- concatenate two tables
local function TableConcat(lhs, rhs)
  for key, value in pairs(rhs) do
    table.insert(lhs, value)
  end
end

-- request viewers for 'channel' from twitch
local function RequestViewers()
  local data = http.request("http://tmi.twitch.tv/group/user/" .. channel .. "/chatters")
  local chatters = json.decode(data).chatters
  viewers = chatters.viewers
  TableConcat(viewers, chatters.vips)
  TableConcat(viewers, chatters.moderators)
end

-- update viewers every 'update_frequency' minutes
local function ExecuteUpdateRoutine()
  -- consider applicants ready to apply for the job again
  applicants = {}
  RequestViewers()
  world:ExecuteFunctionInTime(update_frequency * 60, function()
	ExecuteUpdateRoutine()
  end)
end

-- get ranom viewer name
local function GetRandomViewerName()
  for i = 1, 10 do
	local viewer = viewers[math.random(#viewers)]
	if employees[viewer] == nil and applicants[viewer] == nil then
	  applicants[viewer] = true
	  return viewer
	end
  end
  return nil
end

-- is called if a viewer was hired
local function OnEmployeeComponentUpdated(name)
	employees[name] = true
end

return
{
  ExecuteUpdateRoutine = ExecuteUpdateRoutine,
  GetRandomViewerName = GetRandomViewerName,
  OnEmployeeComponentUpdated = OnEmployeeComponentUpdated
}
