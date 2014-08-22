//fox: Global init script

//Arguments
_aiPlayerGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayerGroupForceLasers") call BIS_fnc_getCfgDataBool;
_aiPlayerGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayerGroupForceSkill") call BIS_fnc_getCfgDataBool;
_aiPlayableUnitsForceLasers = (configFile >> "foxConfig" >> "aiPlayableUnitsForceLasers") call BIS_fnc_getCfgDataBool;
_aiPlayableUnitsForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsForceSkill") call BIS_fnc_getCfgDataBool;

//Oh my grandma what strange syntax you have there
{
	//Add events for AI tweaks on all playable units
	[_x, _aiPlayableUnitsForceLasers, _aiPlayableUnitsForceSkill] execVM '\foxLasers\aiEvents.sqf'
} forEach playableUnits;

//Start referencing player for local player group stuff
//player will never exist on dedicated server machine, so just bail here if this is the case
if (isDedicated) exitWith {}
waitUntil {!isNull player && alive player}

{
	//Add events for AI tweaks on all units in player's group
	[_x, _aiPlayerGroupForceLasers, _aiPlayerGroupForceSkill] execVM '\foxLasers\aiEvents.sqf'

	//Add events for Universal Virtual Arsenal on all units in player's group
	[_x] execVM '\foxLasers\uvaEvents.sqf'
} forEach units group player;
