//fox: Global init script
scopeName "init";

//Preload arsenal so this doesn't happen when player first picks it in-game
["Preload"] call BIS_fnc_arsenal;

//Start referencing player for local player group stuff
//player will never exist on dedicated server machine, so just bail here if this is the case
if (isDedicated) then {
	breakOut "init";
};
waitUntil {!isNull player && alive player};

{
	//Add events for Universal Virtual Arsenal on all units in player's group
	[_x] execVM '\foxUVA\uvaEvents.sqf'
} forEach units group player;
