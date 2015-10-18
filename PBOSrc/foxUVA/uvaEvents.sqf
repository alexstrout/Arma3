//fox: Add events for Universal Virtual Arsenal

//Arguments
_unit = _this select 0;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxUVAEventNeedsInit", true]) then {
	_unit setVariable ["_foxUVAEventNeedsInit", false];

	//Initial state - allow loadouts
	[_unit, "on"] execVM '\foxUVA\uvaSwitchArse.sqf';

	//Unit respawned - allow loadouts again
	_unit addEventHandler ["Respawn", {
		_unit = _this select 0;
		[_unit, "on"] execVM '\foxUVA\uvaSwitchArse.sqf';
	}];
};
