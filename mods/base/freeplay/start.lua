local utils = {}
local mod = {}

utils.session = require("base.utils.session")
utils.session.init_game(scriptPath(), false)
utils.session.add_company(world.PlayerCompanyID)

utils.markets = require("base.utils.markets")
utils.markets.on_init(utils.session.data.market_path, utils.session.data.market_handler)
marketdiscoveryservice:DiscoverMarket(7)


utils.milestones = require("base.utils.milestones")
mod.milestones = require(utils.session.data.milestone_script)
mod.milestones.on_init(utils.session.data.milestone_data, utils.session.data.mod_folder, false)

utils.notifications = require("base.utils.notifications")
utils.notifications.activate_sold_notifications(world.PlayerCompanyID)


--local successtokens = require("base.successtokens.successtokens")
--successtokens.create()
--successtokens.init()


-- twitch integration
utils.twitch = require("base.utils.twitch")

-- update viewers every 'update_frequency' minutes for 'channel' from twitch
utils.twitch.ExecuteUpdateRoutine()

entities:AddApplicantComponentUpdatedCallback(function(entity)
  local name = utils.twitch.GetRandomViewerName()
  if name ~= nil then
	entities:GetNameComponent(entity).Name = name
	entities:UpdateNameComponent(entity)
  end
end)

entities:AddEmployeeComponentUpdatedCallback(function(entity)
  if not entities:GetEmployeeComponent(entity).IsFired then
	utils.twitch.OnEmployeeComponentUpdated(entities:GetNameComponent(entity).Name)
  end
end)
