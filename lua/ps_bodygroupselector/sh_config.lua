local CONFIG = {}

-- Restart map for these to have effect, or reload autorun/ps_bodygroupselector_init.lua

-- [[ Derma ]] --

-- The color of the bar at the top of the window
CONFIG.DermaBar = Color(25, 25, 25)
-- The background of the window
CONFIG.DermaBackground = Color(50, 50, 50)
-- The background of the model rectangle
CONFIG.ModelBackground = Color(50, 150, 255)
-- Is the background dark?
CONFIG.SlidersDark = true

-- [[ Server ]] --

CONFIG.UserGroups = {}
-- User groups that can modify bodygroups (put false to prevent, can also add/remove your own usergroups)

CONFIG.UserGroups['user'] = true
CONFIG.UserGroups['member'] = true
CONFIG.UserGroups['supporter'] = true
CONFIG.UserGroups['vip'] = true
CONFIG.UserGroups['operator'] = true
CONFIG.UserGroups['trialadmin'] = true
CONFIG.UserGroups['admin'] = true
CONFIG.UserGroups['senioradmin'] = true
CONFIG.UserGroups['superadmin'] = true

return CONFIG