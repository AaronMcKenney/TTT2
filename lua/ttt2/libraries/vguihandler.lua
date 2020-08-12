---
-- A vgui handler
-- @author Mineotopia

AddCSLuaFile()

-- the rest of the draw library is client only
if SERVER then return end

local table = table

local function InternalUpdateVSkinSetting(name, panel)
	if name == "blur" then
		panel:SetBackgroundBlur(vskin.ShouldBlurBackground())

		panel:InvalidateLayout()
	elseif name == "skin" then
		panel:InvalidateLayout()
	elseif name == "language" then
		panel:InvalidateLayout()
	elseif name == "general_rebuild" then
		panel:InvalidateLayout()
	end
end

vguihandler = vguihandler or {
	frames = {},
	callback = {
		frame = {},
		hidden = {}
	}
}

-- Call this function to create a new frame.
-- @param number w The width of the panel
-- @param number h The height of the panel
-- @param string title The title of the panel
-- @return @{Panel} The created/cleared DFrameTTT2 object
function vguihandler.GenerateFrame(w, h, title)
	local frame = vgui.Create("DFrameTTT2")
	frame:SetSize(w, h)
	frame:Center()
	frame:SetTitle(title)

	local OriginalClose = frame.Close

	frame.Close = function(slf)
		if slf:GetDeleteOnClose() then
			table.RemoveByValue(vguihandler.frames, frame)
		end

		OriginalClose(slf)
	end

	vguihandler.frames[#vguihandler.frames + 1] = frame

	return frame
end

---
-- Hides all registered and unhidden frames.
-- @return table Returns a table of the frames that are now hidden
-- @realm client
function vguihandler.HideUnhiddenFrames()
	local frames = vguihandler.frames
	local hiddenFrames = {}

	for i = 1, #frames do
		local frame = frames[i]

		if frame:IsFrameHidden() then continue end

		frame:HideFrame()

		hiddenFrames[#hiddenFrames + 1] = frame
	end

	return hiddenFrames
end

---
-- Unhides frames that are listed in a table.
-- @param table A table of frames
-- @realm client
function vguihandler.UnhideFrames(frames)
	for i = 1, #frames do
		local frame = frames[i]

		if not IsValid(frame) or not frame:IsFrameHidden() then continue end

		frame:UnhideFrame()
	end
end

---
-- Unhides all frames that are currently registered and hidden.
-- @realm client
function vguihandler.UnhideAllFrames()
	local frames = vguihandler.frames

	for i = 1, #frames do
		local frame = frames[i]

		if not frame:IsFrameHidden() then continue end

		frame:UnhideFrame()
	end
end

---
-- Should be called when a specific vskin variable is changed
-- so that the complete vgui element is redone
-- @param string name The name of the changed setting
-- @internal
-- @realm client
function vguihandler.UpdateVSkinSetting(name)
	local frames = vguihandler.frames

	for i = 1, #frames do
		InternalUpdateVSkinSetting(name, frames[i])
	end
end

---
-- Rebuilds the whole menu without a specific changed settings
-- @realm client
function vguihandler.Rebuild()
	local frames = vguihandler.frames

	for i = 1, #frames do
		local frame = frames[i]

		if isfunction(frame.OnRebuild) then
			frame:OnRebuild()
		end
	end

	vguihandler.UpdateVSkinSetting("general_rebuild")
end

---
-- Returns if a menu is open or not
-- @return boolean True if a menu is open
-- @realm client
function vguihandler.IsOpen()
	local frames = vguihandler.frames

	for i = 1, #frames do
		if frames[i]:IsFrameHidden() then continue end

		return true
	end

	return false
end
