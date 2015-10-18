//fox: Add events for Universal Virtual Arsenal

//Arguments
_unit = _this select 0;

//Remove old actions and events (if present)
_unit removeEventHandler ["Respawn", _unit getVariable ["_foxUVAEventRespawn", -1]];

//Initial state - allow loadouts
[_unit, "on"] execVM '\foxUVA\uvaSwitchArse.sqf';

//Unit respawned - allow loadouts again
_unit setVariable ["_foxUVAEventRespawn", _unit addEventHandler ["Respawn", {
	_unit = _this select 0;
	[_unit, "on"] execVM '\foxUVA\uvaSwitchArse.sqf';
}]];
