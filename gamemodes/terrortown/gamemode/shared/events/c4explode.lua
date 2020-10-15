if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_c4_explode"
end

if SERVER then
	function EVENT:Trigger(owner)
		local event = {
			nick = owner:Nick(),
			sid64 = owner:SteamID64(),
			role = owner:GetSubRole(),
			team = owner:GetTeam()
		}

		return event
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.nick,
	}
end

function EVENT:Serialize()

end
