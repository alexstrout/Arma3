//fox: Add events for AI tweaks

//Arguments
_unit = _this select 0;
_forceLasers = _this select 1;
_forceSkill = _this select 2;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxAIEventNeedsInit", true]) then {
	_unit setVariable ["_foxAIEventNeedsInit", false];

	//Force-enable lasers
	if (_forceLasers) then {
		_unit setVariable ["_foxAIForceLasers", true];
		_unit enableIRLasers true;
	};

	//Force high skill
	if (_forceSkill) then {
		_unit setVariable ["_foxAIForceSkill", true];
		_unit setSkill 1.0;
		_unit setskill ["aimingAccuracy", 1.0];
		_unit setskill ["aimingShake", 1.0];
		_unit setskill ["aimingSpeed", 1.0];
		_unit setskill ["endurance", 1.0];
		_unit setskill ["spotDistance", 1.0];
		_unit setskill ["spotTime", 1.0];
		_unit setskill ["courage", 1.0];
		_unit setskill ["reloadSpeed", 1.0];
		_unit setskill ["commanding", 1.0];
		_unit setskill ["general", 1.0];
		_unit setUnitAbility 100.0;
		//_unit setCaptive true; //TEST
	};

	//Unit respawned - force lasers / skill again
	_unit addEventHandler ["Respawn", {
		_unit = _this select 0;

		//Force-enable lasers
		if (_unit getVariable ["_foxAIForceLasers", false]) then {
			_unit enableIRLasers true;
		};

		//Force high skill
		if (_unit getVariable ["_foxAIForceSkill", false]) then {
			_unit setSkill 1.0;
			_unit setskill ["aimingAccuracy", 1.0];
			_unit setskill ["aimingShake", 1.0];
			_unit setskill ["aimingSpeed", 1.0];
			_unit setskill ["endurance", 1.0];
			_unit setskill ["spotDistance", 1.0];
			_unit setskill ["spotTime", 1.0];
			_unit setskill ["courage", 1.0];
			_unit setskill ["reloadSpeed", 1.0];
			_unit setskill ["commanding", 1.0];
			_unit setskill ["general", 1.0];
			_unit setUnitAbility 100.0;
			//_unit setCaptive true; //TEST
		};
	}];
};
