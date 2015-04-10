//fox: Action for Universal Virtual Arsenal

//Arguments
_center = _this select 0;

//First off, emulate AmmoBoxInit behavior by adding all available cargo items
[_center, true, true, false] call BIS_fnc_addVirtualWeaponCargo;
[_center, true, true, false] call BIS_fnc_addVirtualMagazineCargo;
[_center, true, true, false] call BIS_fnc_addVirtualItemCargo;
[_center, true, true, false] call BIS_fnc_addVirtualBackpackCargo;

//Next, we need to fix the bug where Load doesn't check _fullArsenal - d'oh!
//TODO do AI under a player get player's insignia? If not we should do that as a bonus easter egg
_tempCurFace = face _center;
_tempCurSpeaker = speaker _center;
_tempCurInsignia = _center call BIS_fnc_getUnitInsignia;

//Oh look, hidden parameters for cargo and focus! We can easily fix the AI issue :)
//If we don't use these, arsenal defaults to player and thus can not be used with AI :(
["Open", [false, _center, _center]] spawn BIS_fnc_arsenal;

//Wait until the screen is opened...
waitUntil {!isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull]) || !alive _center};

//... so we can wait until it's closed and restore our correct face/voice/etc.
waitUntil {isNull (uinamespace getVariable ["BIS_fnc_arsenal_cam", objNull]) || !alive _center};
_center setFace _tempCurFace;
_center setSpeaker _tempCurSpeaker;
[_center, _tempCurInsignia] call BIS_fnc_setUnitInsignia;

//Also broadcast these to all players (may be delayed, so we still want the above for instant local effect)
[[_center, _tempCurFace], "BIS_fnc_setIdentity"] call BIS_fnc_mp;
[[_center, nil, _tempCurSpeaker], "BIS_fnc_setIdentity"] call BIS_fnc_mp;
[[_center, _tempCurInsignia], "BIS_fnc_setUnitInsignia"] call BIS_fnc_mp;

//Cleanup (fixes some potential issues if we die with the screen up - which we can't easily close)
with missionnamespace do {
	BIS_fnc_arsenal_target = nil;
	BIS_fnc_arsenal_center = nil;
	BIS_fnc_arsenal_cargo = nil;
};
