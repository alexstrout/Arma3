//Setup
_uvaMaxDist = (configFile >> "foxConfig" >> "uvaMaxDist") call bis_fnc_getCfgData;
_uvaSynchedPlayer = (configFile >> "foxConfig" >> "uvaSynchedPlayer") call BIS_fnc_getCfgDataBool;
_uvaSynchedPlayableUnits = (configFile >> "foxConfig" >> "uvaSynchedPlayableUnits") call BIS_fnc_getCfgDataBool;
_uvaRepeat = (configFile >> "foxConfig" >> "uvaRepeat") call BIS_fnc_getCfgDataBool;
_aiPlayerGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayerGroupForceLasers") call BIS_fnc_getCfgDataBool;
_aiPlayerGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayerGroupForceSkill") call BIS_fnc_getCfgDataBool;
_aiPlayableUnitsForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsForceSkill") call BIS_fnc_getCfgDataBool;
_firstRun = true;
_validPlayer = false;

//Loop for script's entire lifetime
while {true} do {
	//Check for valid player (may not exist on dedicated server?)
	_validPlayer = !isNull player && alive player;

	//Only run this if repeating or it's our first run
	if (_uvaRepeat || _firstRun) then {
		//Virtual Arsenal - Enable for all objects within radius of player and/or any playable units
		if (_uvaMaxDist > 0) then {
			if (_validPlayer) then {
				{["AmmoboxInit", [_x, true]] spawn BIS_fnc_arsenal} forEach nearestObjects [getPos player, ["ReammoBox", "ReammoBox_F", "LandVehicle", "Air", "Ship"], _uvaMaxDist];
			};
			{{["AmmoboxInit", [_x, true]] spawn BIS_fnc_arsenal} forEach nearestObjects [getPos _x, ["ReammoBox", "ReammoBox_F", "LandVehicle", "Air", "Ship"], _uvaMaxDist]} forEach playableUnits;
		};

		//Virtual Arsenal - Enable for all objects synchronized to player and/or any playable units
		if (_uvaSynchedPlayer && _validPlayer) then {
			{["AmmoboxInit", [_x, true]] spawn BIS_fnc_arsenal} forEach synchronizedObjects player;
		};
		if (_uvaSynchedPlayableUnits) then {
			{{["AmmoboxInit", [_x, true]] spawn BIS_fnc_arsenal} forEach synchronizedObjects _x} forEach playableUnits;
		};
	};

	//AI - Force IR Lasers
	if (_aiPlayerGroupForceLasers && _validPlayer) then {
		group player enableIRLasers true;
	};

	//AI - Force high skill
	if (_aiPlayerGroupForceSkill && _validPlayer) then {
		{_x setSkill 2.0; _x setUnitAbility 2.0} forEach units group player;
		//{_x setCaptive true} forEach units group player; //TEST
	};
	if (_aiPlayableUnitsForceSkill) then {
		{_x setSkill 2.0; _x setUnitAbility 2.0} forEach playableUnits;
		//{_x setCaptive true} forEach playableUnits; //TEST
	};

	//Mark as having run at least once and sleep to conserve cycles
	_firstRun = false;
	sleep 3.0;
};
