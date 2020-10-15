if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_c4_plant"
end

if SERVER then
	function EVENT:Trigger(planter)
		self:AddAffectedPlayers(planter:SteamID64())

		return self:Add({
			nick = planter:Nick(),
			sid64 = planter:SteamID64(),
			role = planter:GetSubRole(),
			team = planter:GetTeam()
		})
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.nick,
	}
end

function EVENT:Serialize()

end
