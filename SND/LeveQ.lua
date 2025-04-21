-- tweaks Debug

QuestGiver = 'Malihali'
QuestTurnIn = 'Ponawme'
JobID = 15
LeveQuest = 1766 -- get by /tweaks Debug
ItemID = 44097 -- https://ffxiv.gamerescape.com/
TurnInNum = 3
UntilAllowance = 40 -- Stop when allownance reach this number

LeveSeq = "13 " .. LeveQuest

while true do
	-- check job
	if GetClassJobId() ~= JobID then 
		yield('/e please change job')
		break
	end
	
	-- Accept quest
	if GetItemCount(ItemID) < TurnInNum then
		yield('/e not enough item to turn-in')
		break
	end
	yield('/target ' .. QuestGiver)
	yield("/interact")
	while (not IsAddonReady("Talk")) do yield('/wait 0.1') end
	while IsAddonReady("Talk") do yield("/click Talk Click") end
	while (not IsAddonReady("SelectString")) do yield('/wait 0.1') end
	yield("/pcall SelectString true 1")
	while not IsAddonReady("JournalDetail") do yield("/wait 0.1") end
	Allowance = GetNodeText("GuildLeve", 5, 2)
	if tonumber(Allowance) <= UntilAllowance then
		yield('/e Allowance = ' .. Allowance)
		yield("/pcall GuildLeve true -1")
		while (not IsAddonReady("SelectString")) do yield('/wait 0.1') end
		yield("/pcall SelectString true -1")
		yield("/wait 0.5")
		break 
	end
	yield("/pcall GuildLeve true 13 " .. LeveSeq)
	yield("/wait 0.5")
	yield("/pcall JournalDetail true 3 " .. LeveQuest)
	yield("/wait 0.5")
	yield("/pcall GuildLeve true -1")
	while (not IsAddonReady("SelectString")) do yield('/wait 0.1') end
	yield("/pcall SelectString true -1")
	yield("/wait 0.5")
	
	-- Turn in
	PandoraSetFeatureState("Auto-select Turn-ins", true)
	PandoraSetFeatureConfigState("Auto-select Turn-ins", "AutoConfirm", true)
	
	yield('/target ' .. QuestTurnIn)
	yield("/interact")
	while (not IsAddonReady("SelectIconString")) do yield('/wait 0.1') end
	yield("/pcall SelectIconString true 0")
	while (not IsAddonReady("Talk")) do yield('/wait 0.1') end
	while IsAddonReady("Talk") do yield("/click Talk Click") end
	while (not IsAddonReady("SelectYesno")) do yield('/wait 0.1') end
	yield("/click SelectYesno Yes")
	while (not IsAddonReady("Talk")) do yield('/wait 0.1') end
	while IsAddonReady("Talk") do yield("/click Talk Click") end
	while (not IsAddonReady("JournalResult")) do yield('/wait 0.1') end
	yield("/click JournalResult Complete")
	PandoraSetFeatureState("Auto-select Turn-ins", false)
	
	-- wait until player available
	while (not IsPlayerAvailable()) do yield('/wait 0.1') end
end