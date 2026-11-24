# Project structure

```
ReplicatedStorage/
  Shared/
    GameConfig.lua

ServerScriptService/
  Modules/
    PlayerDataService.lua
    ClassService.lua

Docs/
  PROJECT_STRUCTURE.md
```

## Installation status

Files in this repository are source code only. Create the matching folders and ModuleScripts in Roblox Studio to install them. They have not yet been tested in an experience.

## Integration checklist

1. Keep the original master script until the new modules are connected and tested.
2. Load player data before applying the saved class or showing saved currencies.
3. Connect PlayerRemoving to PlayerDataService.Release and BindToClose to PlayerDataService.Shutdown.
4. Call PlayerDataService.StartAutosave exactly once from the server bootstrap.
5. On CharacterAdded, call ClassService.ApplySavedClass after the profile and Humanoid exist.
6. Route the existing EquipClass RemoteEvent through ClassService.Equip. Never trust client-provided prices or stats.
7. Route promo codes through PlayerDataService.RedeemCode so a code cannot be claimed twice.
8. Keep the existing boss milestone names and admin identifiers unchanged until explicitly approved.

## Compatibility

The previous master script saved Diamonds under the numeric UserId key in RainforestSaveData. PlayerDataService checks that legacy key and copies its data to Player_<UserId> when the new key is empty. It does not delete the old record. Materials are not saved in this first pass.
