//fox: Add events for Universal Virtual Arsenal

//Arguments
_unit = _this select 0;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxUVAEventInitDone", false]) then {
	_unit setVariable ["_foxUVAEventInitDone", true];

	//Initial state - allow loadouts
	_unit setVariable ["_foxUVAArseAction", _unit addAction ["<t color='#FF6400'>Arsenal (Valid Until Firing)</t>", {
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
		//hint format ["%1 UVA Player Respawned", name _unit]; //TEST
	}];
};
