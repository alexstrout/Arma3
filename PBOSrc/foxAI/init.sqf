//fox: Global init script
scopeName "init";

//Arguments
_aiPlayerGroupForceLasers = true;
_aiPlayerGroupForceSkill = true;
_aiPlayableUnitsGroupForceLasers = false;
_aiPlayableUnitsGroupForceSkill = false;
_aiPlayableUnitsForceSkill = false;
if ((configFile >> "foxConfig" >> "useSettings") call BIS_fnc_getCfgDataBool) then {
	_aiPlayerGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayerGroupForceLasers") call BIS_fnc_getCfgDataBool;
	_aiPlayerGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayerGroupForceSkill") call BIS_fnc_getCfgDataBool;
	_aiPlayableUnitsGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayableUnitsGroupForceLasers") call BIS_fnc_getCfgDataBool;
	_aiPlayableUnitsGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsGroupForceSkill") call BIS_fnc_getCfgDataBool;
	_aiPlayableUnitsForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsForceSkill") call BIS_fnc_getCfgDataBool;
};

//Oh my grandma what strange syntax you have there
{
	{
		//Add events for AI tweaks on all units in playable units' groups
		[_x, _aiPlayableUnitsGroupForceLasers, _aiPlayableUnitsGroupForceSkill] execVM '\foxAI\aiEvents.sqf';
	} forEach units group _x;

	//Add events for AI tweaks on all playable units
	[_x, false, _aiPlayableUnitsForceSkill] execVM '\foxAI\aiEvents.sqf';
} forEach playableUnits;

//Start referencing player for local player group stuff
//player will never exist on dedicated server machine, so just bail here if this is the case
if (isDedicated) then {
	breakOut "init";
};
waitUntil {!isNull player && alive player};

{
	//Add events for AI tweaks on all units in player's group
	[_x, _aiPlayerGroupForceLasers, _aiPlayerGroupForceSkill] execVM '\foxAI\aiEvents.sqf';
} forEach units group player;
