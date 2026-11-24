# 100 Nights: Rainforest Survival — KSJ

Repository source for the Roblox experience.

## Folder map

- ReplicatedStorage/Shared/GameConfig.lua — shared names and balance settings.
- ServerScriptService/Modules/PlayerDataService.lua — profile load/save, legacy migration, currencies, owned classes, selected class, code redemption.
- ServerScriptService/Modules/ClassService.lua — server-side class purchase/equip and character stats.
- Docs/PROJECT_STRUCTURE.md — setup and integration notes.

## Current status

These are prepared source files committed to GitHub. They are not installed in Roblox Studio and have not been tested in a live Roblox experience. GitHub does not automatically sync scripts into Roblox.

Do not delete the existing master script. The next step is to merge these modules into its existing player lifecycle, remote events, leaderstats, promo codes, and respawn logic without creating duplicate handlers.

## Preserved decisions

- 12 biomes and seven class identifiers remain unchanged.
- Normal mode is cooperative.
- Team vs Team requires at least 10 players per team and uses a 30-second matchmaking countdown.
- Lobby stations remain physical lobby objects, not survival HUD buttons.
- Boss milestones remain GrizzlyBear (100), AlienQueen (200), AlienKing (300), GoblinKing (400), ForestGod (500).
- Existing admin names and revenue arrangements are not altered by these files.

## Data compatibility warning

The old master script used the numeric UserId as the key in RainforestSaveData and saved Diamonds only. The new data module checks that old key when the new Player_<UserId> key is empty, then copies the old data forward. It intentionally does not delete the old key.

Wood, Scrap, Metal, and ForestGems are not persisted yet because the old master script did not save them. Decide whether those are permanent currencies or per-run resources before changing the save schema.

## Roblox Studio setup

Create the matching folders in Explorer and add each Lua file as a ModuleScript. Enable DataStore API access only in a separate test experience while validating persistence. Connect PlayerDataService.Load/Release to the existing PlayerAdded/PlayerRemoving flow, start autosave once, call Shutdown from BindToClose, and apply the saved class after the character spawns.
