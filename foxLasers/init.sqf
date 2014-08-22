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

//Oh my grandma what strange syntax you have there
{
	//Initial state - allow loadouts
	_x setVariable ["_uvaArseAction", _x addAction ["<t color='#FF6400'>Arsenal (Valid Until Firing)</t>", {
		//Oh look, hidden parameters! We can easily fix the AI issue :)
		_center = _this select 0;
		["Open", false, missionnamespace, _center] spawn BIS_fnc_arsenal;

		//... But we still need to set them manually :(
		waitUntil {!isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull])};
		with missionnamespace do {
			BIS_fnc_arsenal_cargo = missionnamespace;
			BIS_fnc_arsenal_center = _center;
			[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualWeaponCargo;
			[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualMagazineCargo;
			[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualItemCargo;
			[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualBackpackCargo;
		};

		//... And we need to fix the bug where Load doesn't check _fullArsenal - d'oh!
		//TODO do AI under a player get player's insignia? If not we should do that as a bonus easter egg
		_tempCurFace = face _center;
		_tempCurSpeaker = speaker _center;
		_tempCurInsignia = _center call BIS_fnc_getUnitInsignia;
		waitUntil {isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull])};
		_center setFace _tempCurFace;
		_center setSpeaker _tempCurSpeaker;
		[_center, _tempCurInsignia] call BIS_fnc_setUnitInsignia;
	}]];

	//Unit fired - count as combat, disallow loadout for rest of life
	_x addEventHandler ["Fired", {
		(_this select 0) removeAction ((_this select 0) getVariable ["_uvaArseAction", -1]);
		hint format ["%1 UVA Player Fired", name (_this select 0)]; //TEST
	}];

	//Unit killed - disallow loadout for rest of next life (otherwise could freely Arsenal off corpse)
	_x addEventHandler ["Killed", {
		(_this select 0) removeAction ((_this select 0) getVariable ["_uvaArseAction", -1]);
		hint format ["%1 UVA Player Killed", name (_this select 0)]; //TEST
	}];

	//Unit respawned - allow loadouts again
	_x addEventHandler ["Respawn", {
		(_this select 0) setVariable ["_uvaArseAction", (_this select 0) addAction ["<t color='#FF6400'>Arsenal (Valid Until Firing)</t>", {
			//Oh look, hidden parameters! We can easily fix the AI issue :)
			_center = _this select 0;
			["Open", false, missionnamespace, _center] spawn BIS_fnc_arsenal;
	
			//... But we still need to set them manually
			waitUntil {!isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull])};
			with missionnamespace do {
				BIS_fnc_arsenal_cargo = missionnamespace;
				BIS_fnc_arsenal_center = _center;
				[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualWeaponCargo;
				[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualMagazineCargo;
				[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualItemCargo;
				[BIS_fnc_arsenal_cargo, true, true, false] call bis_fnc_addVirtualBackpackCargo;
			};
	
			//... And we need to fix the bug where Load doesn't check _fullArsenal - d'oh!
			//TODO do AI under a player get player's insignia? If not we should do that as a bonus easter egg :)
			_tempCurFace = face _center;
			_tempCurSpeaker = speaker _center;
			_tempCurInsignia = _center call BIS_fnc_getUnitInsignia;
			waitUntil {isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull])};
			_center setFace _tempCurFace;
			_center setSpeaker _tempCurSpeaker;
			[_center, _tempCurInsignia] call BIS_fnc_setUnitInsignia;
		}]];
		hint format ["%1 UVA Player Respawned", name (_this select 0)]; //TEST
	}];
} forEach units group player;

//Add UVA event handlers for all playable units
{if (isNil {_x getVariable "_uvaEventInitDone"}) then {
	//Don't add another event handler to this
	_x setVariable ["_uvaEventInitDone", true];

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

	//Unit respawned - allow loadouts again
	_x addEventHandler ["Respawn", {
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

			//Unit respawned - force-enable lasers and high skill if appropriate
			_x addEventHandler ["Respawn", {
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
		}} forEach units group player;

		//Don't run this again
		_uvaPlayerGroupInit = true;
	};

	//Sleep to conserve cycles
	sleep 5.0;
};
