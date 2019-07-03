# PointShop BodyGroup Selector
This is an addon for the original PointShop that will allow you to customize the playermodels and or skins of the models on the pointshop (provided the models have them).

# Installation
Just put on the addons folder and restart the server/game, you'll need to restart the map for each change you do to an item.

## Enabling selector
To know what to add, as a super admin type into console `ps_bodygroupselector_preview` and if your model has bodygroups or skins, you'll see sliders, it goes like this:

If the model has skins, a slider with the name `Skin` will appear, simple.\
If the model has bodygroups, sliders will appear, their names will indicate what they are and the number between the [ ] will indicate their ids, for example `[2] Hair` indicating that the bodygroup with id 2 modifies the hair.

To enable the selector on a model you need to add skins and/or bodygroups to its item.
You don't need to add both Skins and Bodygroups.

```lua
ITEM.Skins = { 0, 1, 2 } -- You can skip numbers here, let's say, you don't like skin 1? Just remove it from the table.

ITEM.Bodygroups = {
	['Name to display'] = { id = 1, values = { 0, 1, 2 } }, -- Remember the number between the [ ] ?
	['Hair'] = { id = 2, values = { 1, 3 } }, -- This way you'll only be able to choose between hairstyle 1 and 3
}
```

Remember that not all playermodels have bodygroups and skins, if you see no sliders, it's because there are no bodygroups and there are no skins for that model.

One last step! You need to add `self:SetBodygroups(ply, modifications)` below `ply:SetModel(self.Model)`.

After restarting the map, having the model equipped, click on it again and you'll see a `Modify` button.

## Settings
Inside `lua\ps_bodygroupselector\sh_config.lua` there are various settings for customizing, they are also commented so I don't have to explain them here. If you change the config, restart your map for the changes to take effect.\
If after using the selector, you go to another model and it looks weird, remember to check its bodygroups/skins and either enable the picker, or force the bodygroups to stay 0 (or another number if you want) adding this below `ply:SetModel(self.Model)` : \
`ply:SetBodygroup(X, 0)` replacing X with the ID of the bodygroup. You can also do that with skins if that's what wrong: `ply:SetSkin(0)`.