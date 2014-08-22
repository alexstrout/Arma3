//Setup
_uvaMaxDist = (configFile >> "foxConfig" >> "uvaMaxDist") call bis_fnc_getCfgData;
_uvaSynchedPlayer = (configFile >> "foxConfig" >> "uvaSynchedPlayer") call BIS_fnc_getCfgDataBool;
_uvaSynchedPlayableUnits = (configFile >> "foxConfig" >> "uvaSynchedPlayableUnits") call BIS_fnc_getCfgDataBool;
_uvaRepeat = (configFile >> "foxConfig" >> "uvaRepeat") call BIS_fnc_getCfgDataBool;
_aiPlayerGroupForceLasers = (configFile >> "foxConfig" >> "aiPlayerGroupForceLasers") call BIS_fnc_getCfgDataBool;
_aiPlayableUnitsForceLasers = true;
_aiPlayerGroupForceSkill = (configFile >> "foxConfig" >> "aiPlayerGroupForceSkill") call BIS_fnc_getCfgDataBool;
_aiPlayableUnitsForceSkill = (configFile >> "foxConfig" >> "aiPlayableUnitsForceSkill") call BIS_fnc_getCfgDataBool;
_uvaPlayerGroupInit = false;
_validPlayer = false;

//Add UVA event handlers for all playable units
{if (isNil {_x getVariable "_uvaEventInitDone"}) then {
	//Don't add another event handler to this
	_x setVariable ["_uvaEventInitDone", true];

	//Initial state
	_x setVariable ["_uvaArseAction", _x addAction ["Arsenal (Valid Until Firing)", {
		["Open", false] spawn BIS_fnc_arsenal;
		with missionnamespace do {
			BIS_fnc_arsenal_cargo = (_this select 0);
			BIS_fnc_arsenal_center = (_this select 0);
		};
		[(_this select 0), true, true, false] call bis_fnc_addVirtualWeaponCargo;
		[(_this select 0), true, true, false] call bis_fnc_addVirtualMagazineCargo;
		[(_this select 0), true, true, false] call bis_fnc_addVirtualItemCargo;
		[(_this select 0), true, true, false] call bis_fnc_addVirtualBackpackCargo;
	}]];

	//AI - Force-enable lasers
	if (_aiPlayableUnitsForceLasers) then {
		_x setVariable ["_aiForceLasers", true];
		_x enableIRLasers true;
	};

	//AI - Force high skill
	if (_aiPlayableUnitsForceSkill) then {
		_x setVariable ["_aiForceSkill", true];
		_x setSkill 2.0;
		_x setUnitAbility 2.0;
		_x setCaptive true; //TEST
	};

	//Unit fired - disallow loadout for rest of life
	_x addEventHandler ["Fired", {
		(_this select 0) removeAction ((_this select 0) getVariable ["_uvaArseAction", -1]);
		hint format ["%1 Playable Fired", name (_this select 0)]; //TEST
	}];

	//Unit respawned - allow loadouts again - also force lasers and high skill if appropriate
	_x addEventHandler ["Respawn", {
		(_this select 0) setVariable ["_uvaArseAction", (_this select 0) addAction ["Arsenal (Valid Until Firing)", {["Open", true] spawn BIS_fnc_arsenal}]];
		hint format ["%1 Playable Respawned", name (_this select 0)]; //TEST

		//AI - Force-enable lasers
		if ((_this select 0) getVariable ["_aiForceLasers", false]) then {
			(_this select 0) enableIRLasers true;
		};

		//AI - Force high skill
		if ((_this select 0) getVariable ["_aiForceSkill", false]) then {
			(_this select 0) setSkill 2.0;
			(_this select 0) setUnitAbility 2.0;
			(_this select 0) setCaptive true; //TEST
		};
	}];

	//Unit respawned - allow loadouts again
// 	_x addMPEventHandler ["MPRespawn", {
// 		(_this select 0) setVariable ["_uvaArseAction", (_this select 0) addAction ["Arsenal (Valid Until Firing)", {["Open", true] spawn BIS_fnc_arsenal}]];
// 		hint format ["%1 Playable MPRespawned", name (_this select 0)]; //TEST
//
// 		//AI - Force-enable lasers
// 		if ((_this select 0) getVariable ["_aiForceLasers", false]) then {
// 			(_this select 0) enableIRLasers true;
// 		};
//
// 		//AI - Force high skill
// 		if ((_this select 0) getVariable ["_aiForceSkill", false]) then {
// 			(_this select 0) setSkill 2.0;
// 			(_this select 0) setUnitAbility 2.0;
// 			(_this select 0) setCaptive true; //TEST
// 		};
// 	}];
}} forEach playableUnits;

//Loop for script's entire lifetime
while {true} do {
	//Check for valid player (may not exist on dedicated server?)
	_validPlayer = !isNull player && alive player;

	//Add UVA event handlers for all units in player's group
	//TODO HACK: Done here as we don't want to hold up the script with waitUntil
	if (!_uvaPlayerGroupInit && _validplayer) then {
		{if (isNil {_x getVariable "_uvaEventInitDone"}) then {
			//Don't add another event handler to this
			_x setVariable ["_uvaEventInitDone", true];

			//Initial state
			_x setVariable ["_uvaArseAction", _x addAction ["Arsenal (Valid Until Firing)", {["Open", true] spawn BIS_fnc_arsenal}]];

			//AI - Force-enable lasers
			if (_aiPlayerGroupForceLasers) then {
				_x setVariable ["_aiForceLasers", true];
				_x enableIRLasers true;
			};

			//AI - Force high skill
			if (_aiPlayerGroupForceSkill) then {
				_x setVariable ["_aiForceSkill", true];
				_x setSkill 2.0;
				_x setUnitAbility 2.0;
				_x setCaptive true; //TEST
			};

			//Unit fired - disallow loadout for rest of life
			_x addEventHandler ["Fired", {
				(_this select 0) removeAction ((_this select 0) getVariable ["_uvaArseAction", -1]);
				hint format ["%1 Playable Fired", name (_this select 0)]; //TEST
			}];

			//Unit respawned - allow loadouts again - also force lasers and high skill if appropriate
			_x addEventHandler ["Respawn", {
				(_this select 0) setVariable ["_uvaArseAction", (_this select 0) addAction ["Arsenal (Valid Until Firing)", {["Open", true] spawn BIS_fnc_arsenal}]];
				hint format ["%1 Playable Respawned", name (_this select 0)]; //TEST

				//AI - Force-enable lasers
				if ((_this select 0) getVariable ["_aiForceLasers", false]) then {
					(_this select 0) enableIRLasers true;
				};

				//AI - Force high skill
				if ((_this select 0) getVariable ["_aiForceSkill", false]) then {
					(_this select 0) setSkill 2.0;
					(_this select 0) setUnitAbility 2.0;
					(_this select 0) setCaptive true; //TEST
				};
			}];

			//Unit respawned - allow loadouts again
// 			_x addMPEventHandler ["MPRespawn", {
// 				(_this select 0) setVariable ["_uvaArseAction", (_this select 0) addAction ["Arsenal (Valid Until Firing)", {["Open", true] spawn BIS_fnc_arsenal}]];
// 				hint format ["%1 Playable MPRespawned", name (_this select 0)]; //TEST
//
// 				//AI - Force-enable lasers
// 				if ((_this select 0) getVariable ["_aiForceLasers", false]) then {
// 					(_this select 0) enableIRLasers true;
// 				};
//
// 				//AI - Force high skill
// 				if ((_this select 0) getVariable ["_aiForceSkill", false]) then {
// 					(_this select 0) setSkill 2.0;
// 					(_this select 0) setUnitAbility 2.0;
// 					(_this select 0) setCaptive true; //TEST
// 				};
// 			}];
		}} forEach units group player;

		//Don't run this again
		_uvaPlayerGroupInit = true;
	};

	//Sleep to conserve cycles
	sleep 5.0;
};
