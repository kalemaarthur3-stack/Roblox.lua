# 100 Nights: Rainforest Survival — KSJ

Roblox game source repository.

## Source folders

- `ReplicatedStorage/Shared` — shared game configuration.
- `ServerScriptService/Modules` — server data and class modules.
- `StarterPlayer/StarterPlayerScripts/GUI` — client GUI LocalScripts.
- `Docs` — setup and integration notes.

## Current source set

### Core
- `ReplicatedStorage/Shared/GameConfig.lua`
- `ServerScriptService/Modules/PlayerDataService.lua`
- `ServerScriptService/Modules/ClassService.lua`

### GUIs
- `StarterPlayer/StarterPlayerScripts/GUI/SurvivalHUD.client.lua`
- `StarterPlayer/StarterPlayerScripts/GUI/ClassSelection.client.lua`
- `StarterPlayer/StarterPlayerScripts/GUI/LobbyMenu.client.lua`
- `StarterPlayer/StarterPlayerScripts/GUI/LobbyStations.client.lua`
- `StarterPlayer/StarterPlayerScripts/GUI/CampfireHealth.client.lua`

## Preserved decisions

- 12 biomes and seven class identifiers remain unchanged.
- Normal mode is cooperative.
- Team vs Team requires at least 10 players per team and a 30-second matchmaking countdown.
- Lobby stations remain physical lobby objects, not survival HUD buttons.
- Campfire health is displayed above the in-world campfire.
- Boss milestones remain GrizzlyBear (100), AlienQueen (200), AlienKing (300), GoblinKing (400), ForestGod (500).

## Status

The files are uploaded source code, not installed or tested in Roblox Studio. The original master script must remain in place until the modules, remotes and GUI triggers are integrated and tested. See `Docs/GUI_SETUP.md` and `Docs/PROJECT_STRUCTURE.md`.
