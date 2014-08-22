//fox: Add events for Universal Virtual Arsenal

//Arguments
_unit = _this select 0;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxUVAEventInitDone", false]) then {
	_unit setVariable ["_foxUVAEventInitDone", true];

	//Initial state - allow loadouts
	_unit setVariable ["_foxUVAArseAction", _unit addAction ["<t color='#FF6400'>Arsenal (Valid Until Firing)</t>", {
		[_this select 0] execVM '\foxLasers\uvaActionUseArse.sqf'
	}]];

	//Unit fired - count as combat, disallow loadout for rest of life
	_unit addEventHandler ["Fired", {
		_unit = _this select 0;
		_unit removeAction (_unit getVariable ["_foxUVAArseAction", -1]);
		//hint format ["%1 UVA Player Fired", name _unit]; //TEST
	}];

	//Unit killed - disallow loadout for rest of next life (otherwise could freely Arsenal off corpse)
	_unit addEventHandler ["Killed", {
		_unit = _this select 0;
		_unit removeAction (_unit getVariable ["_foxUVAArseAction", -1]);
		//hint format ["%1 UVA Player Killed", name _unit]; //TEST
	}];

	//Unit respawned - allow loadouts again
	_unit addEventHandler ["Respawn", {
		_unit = _this select 0;
		_unit setVariable ["_foxUVAArseAction", _unit addAction ["<t color='#FF6400'>Arsenal (Valid Until Firing)</t>", {
			[_this select 0] execVM '\foxLasers\uvaActionUseArse.sqf'
		}]];
		//hint format ["%1 UVA Player Respawned", name _unit]; //TEST
	}];
};
