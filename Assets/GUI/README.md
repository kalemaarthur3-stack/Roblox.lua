# KSJ Rainforest Survival GUI Image Assets

## Icon atlas source

- `KSJ_Rainforest_GUI_Icon_Atlas.svg` is the editable vector source for the first GUI icon set.
- It contains 24 rainforest-themed icons: six resources, seven classes, lobby stations, game modes, campfire, and health.
- Visual style: dark rainforest green, leaf-green outlines, gold highlights, and bright resource colors.

## Important Roblox limitation

Roblox image objects do not display SVG files directly. This SVG is the source artwork and must be exported to PNG before it can be uploaded as a Roblox image asset. After export, the PNG must be uploaded through Roblox Creator Dashboard / Studio, and the resulting Roblox asset ID must be placed into the GUI scripts.

## Atlas layout

- Canvas: 1200 x 1200
- Grid: 5 columns x 5 rows (last cell unused)
- Cell step: 232 x 216
- Icon artwork cell: 216 x 204
- First cell origin: x=20, y=80
- Cell origin for zero-based column `c`, row `r`: x = 20 + 232*c, y = 80 + 216*r
- Use the cell origin and cell dimensions when exporting individual icon PNGs, or use Roblox ImageRectOffset / ImageRectSize with an exported PNG atlas.

## Included icons

Diamonds, Coins, Wood, Scrap, Metal, Forest Gems, Camper, Hunter, Medic, Alien, Cyborg, Shadow Ninja, Beast Master, Shop, Rewards, Trading, Leaderboard, Quests, Settings, Normal Mode, PvP Mode, Team vs Team, Campfire, Health.

## Current integration status

The icon artwork source is in the repository. It has not yet been exported to Roblox-ready PNG files or uploaded to Roblox, so no Roblox image asset IDs are assigned yet. The existing GUI scripts continue to use their current text/icon fallback UI until those IDs are supplied.
