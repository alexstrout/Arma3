//fox: Global init script
scopeName "init";

//Arguments
_aiPlayerGroupForceLasers = true;
_aiPlayerGroupForceSkill = true;
_aiPlayableUnitsForceLasers = false;
_aiPlayableUnitsForceSkill = true;
if ((configFile >> "foxConfig" >> "useSettings") call BIS_fnc_getCfgDataBool) then {
	_aiPlayerGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayerGroupForceLasers") call BIS_fnc_getCfgDataBool;
	_aiPlayerGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayerGroupForceSkill") call BIS_fnc_getCfgDataBool;
	_aiPlayableUnitsForceLasers = (configFile >> "foxConfig" >> "aiPlayableUnitsForceLasers") call BIS_fnc_getCfgDataBool;
	_aiPlayableUnitsForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsForceSkill") call BIS_fnc_getCfgDataBool;
};

//Preload arsenal so this doesn't happen when player first picks it in-game
["Preload"] call BIS_fnc_arsenal;

//Oh my grandma what strange syntax you have there
{
	//Add events for AI tweaks on all playable units
	[_x, _aiPlayableUnitsForceLasers, _aiPlayableUnitsForceSkill] execVM '\foxLasers\aiEvents.sqf';
} forEach playableUnits;

//Start referencing player for local player group stuff
//player will never exist on dedicated server machine, so just bail here if this is the case
if (isDedicated) then {
	breakOut "init";
};
waitUntil {!isNull player && alive player};

{
	//Add events for AI tweaks on all units in player's group
	[_x, _aiPlayerGroupForceLasers, _aiPlayerGroupForceSkill] execVM '\foxLasers\aiEvents.sqf';

	//Add events for Universal Virtual Arsenal on all units in player's group
	[_x] execVM '\foxLasers\uvaEvents.sqf'
} forEach units group player;
