//fox: Action for Universal Virtual Arsenal

//Arguments
_center = _this select 0;

//Oh look, hidden parameters! We can easily fix the AI issue :)
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
