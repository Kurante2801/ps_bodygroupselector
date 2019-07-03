local CONFIG = include('ps_bodygroupselector/sh_config.lua')

-- After game is loaded, create modify functions for each item that has bodygroups and/or skins
hook.Add('InitPostEntity', 'PS_BodygroupSelector.Enable', function()
	-- Loop through items
	for id, item in pairs(PS.Items) do
		-- If item doesn't have any bodygroup nor has skins, stop
		if !item.Skins && !item.Bodygroups then continue end

		function item:OnModify(ply, mods)
			-- Stop if player can't change
			if !CONFIG.UserGroups[ply:GetUserGroup()] then
				ply:ChatPrint('You do not have permission to use the bodygroup selector.')
				return
			end
			-- Store old model
			local old = ply._OldModel
			-- Reload model
			self:OnEquip(ply, mods)
			-- Restore old model
			ply._OldModel = old
		end

		function item:SanitizeTable(mods)
			-- Allow only numbers
			for name, mod in pairs(mods) do
				if TypeID(mod) != TYPE_NUMBER then
					mods[name] = nil
				end
			end
			return mods
		end

		function item:SetBodygroups(ply, mods)
			-- Stop if player can't change
			if !CONFIG.UserGroups[ply:GetUserGroup()] then
				ply:ChatPrint('You do not have permission to use the bodygroup selector.')
				return
			end
			-- If item has a skins table, set skin
			if self.Skins then
				ply:SetSkin(self.Skins[mods.Skin || 1] || 0)
			end
			-- Same with bodygroups
			for name, bg in pairs(self.Bodygroups || {}) do
				ply:SetBodygroup(bg.id, bg.values[mods['BG_' .. bg.id]] || 0)
			end
		end

		-- Replace pointshop item
		PS.Items[id] = item
	end
end)

-- Receive a request to send a player's model, because getting it on the client would make an invalid path most of the time
util.AddNetworkString('PS_BodygroupSelector.Preview')
util.AddNetworkString('PS_BodygroupSelector.ModelPreview')
net.Receive('PS_BodygroupSelector.Preview', function(_, ply)
	if !ply:IsSuperAdmin() then return end

	net.Start('PS_BodygroupSelector.ModelPreview')
		net.WriteString(ply:GetModel())
	net.Send(ply)
end)