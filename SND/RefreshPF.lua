while Addons.GetAddon("LookingForGroup").Ready do
	yield('/callback LookingForGroup true 17')
	yield('/wait 10') -- delay
end