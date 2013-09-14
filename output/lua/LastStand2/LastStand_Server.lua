// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Server_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

/**
 * Map entities with a higher priority are loaded first.
 */
Script.Load("lua/LastStand/LastStand_Shared.lua")

// Hooks for files that are not in Shared.lua need to go here.
Script.Load("lua/LastStand/AlienTeam.lua")