//fox: Add events for AI tweaks

//Arguments
_unit = _this select 0;
_forceLasers = _this select 1;
_forceSkill = _this select 2;

//Operate on unit if events haven't already been set on unit
if (_unit getVariable ["_foxAIEventInitDone", false]) then {
	_unit setVariable ["_foxAIEventInitDone", true];

	//Force-enable lasers
	if (_forceLasers) then {
		_unit setVariable ["_foxAIForceLasers", true];
		_unit enableIRLasers true;
	};

	//Force high skill
	if (_forceSkill) then {
		_unit setVariable ["_foxAIForceSkill", true];
		_unit setSkill 2.0;
		_unit setUnitAbility 2.0;
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
			_unit setSkill 2.0;
			_unit setUnitAbility 2.0;
			//_unit setCaptive true; //TEST
		};
	}];
};
