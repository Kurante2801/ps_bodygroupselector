-- https://steamcommunity.com/sharedfiles/filedetails/?id=1794836738

ITEM.Name = "Bodygroups Example"
ITEM.Price = 10
ITEM.Model = "models/player/lordvipes/h3_spartans_mps/h3spartan_mps_cvp.mdl"
ITEM.AllowedUserGroups = { "superadmin" }

-- Bodygroup picker
ITEM.Bodygroups = {
	["Helmet"] = { id = 1, values = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
	["Chest"] = { id = 2, values = { 0, 1, 2, 3, 4, 5, 6 } },
	["Left Shoulder"] = { id = 3, values = { 0, 1, 2, 3, 4, 5, 6, 7 } },
	["Right Shoulder"] = { id = 4, values = { 0, 1, 2, 3, 4, 5, 6, 7 } },
	["Katana"] = { id = 5, values = { 0, 1 } },
	["Decals"] = { id = 6, values = { 0, 1 } },
}

-- No skins

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end

	timer.Simple (2, function()
		ply:SetModel(self.Model)
		-- Set bodygroups
		self:SetBodygroups (ply, modifications)
	end)
end


function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
	end
end