//fox: Add ability to use Universal Virtual Arsenal
scopeName "uvaSwitchArse";

//Arguments
_unit = _this select 0;
_mode = _this select 1; //see switch block

//Remove old actions and events (if present)
_unit removeAction (_unit getVariable ["_foxUVAArseAction", -1]);
_unit removeEventHandler ["InventoryOpened", _unit getVariable ["_foxUVAEventInvOpened", -1]];
_unit removeEventHandler ["Fired", _unit getVariable ["_foxUVAEventFired", -1]];
_unit removeEventHandler ["Killed", _unit getVariable ["_foxUVAEventKilled", -1]];

//Add context-sensitive actions and events
switch _mode do {
	//Exit - do nothing, since we already removed relevant actions and events above
	//Note: Needed since we (re)add common events after this switch block
	case "exit": {
		breakOut "uvaSwitchArse";
	};

	//Turn "on" - add Arsenal ability via inventory
	case "on": {
		//Add toggle action to turn "off"
		_unit setVariable ["_foxUVAArseAction", _unit addAction ["<t color='#0064FF'>Arsenal -> Inventory (Forced When Firing)</t>", {
			[_this select 0, "off"] execVM '\foxLasers\uvaSwitchArse.sqf';
		}, nil, 1.500881, false, true, "", "vehicle _this == vehicle _target"]];

		//Inventory opened - Arsenal up!
		_unit setVariable ["_foxUVAEventInvOpened", _unit addEventHandler ["InventoryOpened", {
			[_this select 0] execVM '\foxLasers\uvaActionUseArse.sqf';
			true;
		}]];
	};

	//Turn "off" - remove Arsenal ability via inventory
	case "off": {
		//Add toggle action to turn "on"
		_unit setVariable ["_foxUVAArseAction", _unit addAction ["<t color='#FF6400'>Inventory -> Arsenal (Valid Until Firing)</t>", {
			[_this select 0, "on"] execVM '\foxLasers\uvaSwitchArse.sqf';
		}, nil, 1.500881, false, true, "", "vehicle _this == vehicle _target"]];
	};
};

//Add common actions and events (everything except "exit")
//Note: Here (instead of uvaEvents) so that these events will stay removed on "exit" as they will no longer be needed
//Unit fired - disallow loadout for rest of life
_unit setVariable ["_foxUVAEventFired", _unit addEventHandler ["Fired", {
	[_this select 0, "exit"] execVM '\foxLasers\uvaSwitchArse.sqf';
}]];

//Unit killed - disallow loadout for rest of life (otherwise could freely Arsenal off corpse and other weirdness)
_unit setVariable ["_foxUVAEventKilled", _unit addEventHandler ["Killed", {
	[_this select 0, "exit"] execVM '\foxLasers\uvaSwitchArse.sqf';
}]];
