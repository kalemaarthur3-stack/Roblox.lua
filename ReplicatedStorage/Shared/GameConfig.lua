-- 100 Nights: Rainforest Survival | KSJ
-- ModuleScript: ReplicatedStorage/Shared/GameConfig

local GameConfig = {
    GameName = "100 Nights: Rainforest Survival",
    Brand = "KSJ",
    Nights = { StartingNight = 1, StandardLimit = 100, EndlessEnabled = false },

    Biomes = {
        "Rainforest", "FireLands", "SnowMountains", "WaterSwamp",
        "AutumnForest", "ShadowBiome", "AlienCrashZone", "StormPlains",
        "DesertWasteland", "SpiritForest", "CrystalCaverns", "DeepOcean",
    },

    Classes = {
        Camper = { MaxHealth = 120, WalkSpeed = 16, StartingItem = "Torch", Cost = 0, Starter = true },
        Hunter = { MaxHealth = 100, WalkSpeed = 18, StartingItem = "Bow", Cost = 0, Starter = true },
        Medic = { MaxHealth = 110, WalkSpeed = 16, StartingItem = "Bandages", Cost = 0, Starter = true },
        Alien = { MaxHealth = 150, WalkSpeed = 20, StartingItem = "LaserCannon", Cost = 500, Starter = false },
        Cyborg = { MaxHealth = 180, WalkSpeed = 14, StartingItem = "ShockRifle", Cost = 700, Starter = false },
        ShadowNinja = { MaxHealth = 90, WalkSpeed = 25, StartingItem = "DualBlades", Cost = 1000, Starter = false },
        BeastMaster = { MaxHealth = 130, WalkSpeed = 17, StartingItem = "Spear", Cost = 800, Starter = false },
    },

    Resources = { "Diamonds", "Coins", "Wood", "Scrap", "Metal", "ForestGems" },

    Modes = {
        Normal = { TeamBased = true, Description = "Everyone survives together." },
        PvP = { TeamBased = false, Description = "Players fight each other." },
        TeamVsTeam = {
            TeamBased = true,
            MinimumPlayersPerTeam = 10,
            MatchmakingCountdown = 30,
            Teams = { "Red", "Blue" },
        },
    },

    BossMilestones = {
        [100] = "GrizzlyBear",
        [200] = "AlienQueen",
        [300] = "AlienKing",
        [400] = "GoblinKing",
        [500] = "ForestGod",
    },
}

return GameConfig
