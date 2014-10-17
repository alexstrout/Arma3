//fox: Add events for Universal Virtual Arsenal

//Arguments
_unit = _this select 0;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxUVAEventInitDone", true]) then {
	_unit setVariable ["_foxUVAEventInitDone", true];

	//Initial state - allow loadouts
	[_unit, "on"] execVM '\foxLasers\uvaSwitchArse.sqf';

	//Unit respawned - allow loadouts again
	_unit addEventHandler ["Respawn", {
		_unit = _this select 0;
		[_unit, "on"] execVM '\foxLasers\uvaSwitchArse.sqf';
	}];
};
