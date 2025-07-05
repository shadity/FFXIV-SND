QuestGiver = 'Malihali'
QuestTurnIn = 'Ponawme'
JobID = 15
LeveQuest = 1766 -- get by /tweaks Debug
ItemID = 44097 -- https://ffxiv.gamerescape.com/
TurnInNum = 3
UntilAllowance = 40 -- Stop when allownance reach this number

LeveSeq = "13 " .. LeveQuest

function CheckCondition()
	-- check job
	if Player.Job.Id ~= JobID then 
		yield('/e please change job')
		return false
	end
	
	-- check number of item
	if Inventory.GetHqItemCount(ItemID) < TurnInNum then
		yield('/e not enough item to turn-in')
		return false
	end
	return true
end

function AcceptQuest()
	yield('/target ' .. QuestGiver)
	yield("/interact")
	while (not Addons.GetAddon("Talk").Ready) do yield('/wait 0.1') end
	while Addons.GetAddon("Talk").Ready do yield("/click Talk Click") end
	while (not Addons.GetAddon("SelectString").Ready) do yield('/wait 0.1') end
	yield("/callback SelectString true 1")
	while not Addons.GetAddon("GuildLeve").Ready do yield("/wait 0.1") end
	Allowance = Addons.GetAddon("GuildLeve"):GetNode(1,28,30,2).Text
	if tonumber(Allowance) <= UntilAllowance then
		yield('/e Allowance = ' .. Allowance)
		yield("/callback GuildLeve true -1")
		while (not Addons.GetAddon("SelectString").Ready) do yield('/wait 0.1') end
		yield("/callback SelectString true -1")
		yield("/wait 0.5")
		return false
	end
	yield("/callback GuildLeve true 13 " .. LeveSeq)
	yield("/wait 0.5")
	yield("/callback JournalDetail true 3 " .. LeveQuest)
	yield("/wait 0.5")
	yield("/callback GuildLeve true -1")
	while (not Addons.GetAddon("SelectString").Ready) do yield('/wait 0.1') end
	yield("/callback SelectString true -1")
	-- wait until player available
	while Player.IsBusy do yield('/wait 0.1') end
	return true
end

function TurnIn()
	yield('/target ' .. QuestTurnIn)
	yield("/interact")
	while ((not Addons.GetAddon("Talk").Ready) and (not Addons.GetAddon("SelectString").Ready)) do yield('/wait 0.1') end
	-- For case accepted more than 1 quest
	if Addons.GetAddon("SelectString").Ready then
		yield("/callback SelectIconString true 0")
		while (not Addons.GetAddon("Talk").Ready) do yield('/wait 0.1') end
	end
	while Addons.GetAddon("Talk").Ready do yield("/click Talk Click") end
	while (not Addons.GetAddon("SelectYesno").Ready) do yield('/wait 0.1') end
	yield("/click SelectYesno Yes")
	while (not Addons.GetAddon("Talk").Ready) do yield('/wait 0.1') end
	while Addons.GetAddon("Talk").Ready do yield("/click Talk Click") end
	while (not Addons.GetAddon("JournalResult").Ready) do yield('/wait 0.1') end
	yield("/click JournalResult Complete")
	-- wait until player available
	while Player.IsBusy do yield('/wait 0.1') end
end

IPC.PandorasBox.SetFeatureEnabled("Auto-select Turn-ins", true)
IPC.PandorasBox.SetConfigEnabled("Auto-select Turn-ins", "AutoConfirm", true)

while true do
	if not CheckCondition() then
		break
	end
	if not AcceptQuest() then
		break
	end
	TurnIn()
end

IPC.PandorasBox.SetConfigEnabled("Auto-select Turn-ins", "AutoConfirm", false)
IPC.PandorasBox.SetFeatureEnabled("Auto-select Turn-ins", false)