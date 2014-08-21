class CfgPatches {
	class foxLasers {
		units[] = {};
		weapons[] = {};
		//requiredAddons[] = {};
		requiredAddons[] = {"CBA_Extended_EventHandlers"};
		version = "0.01";
		versionStr = "0.01";
		versionDesc= "Universal Virtual Arsenal + AI Tweaks";
		versionAr[] = {0,0,1};
		author[] = {"fox"};
	};
};

// class CfgFunctions {
// 	class foxLasers {
// 		file = "\foxLasers\init.sqf";
// 		postInit = 1;
// 	};
// };
//
class Extended_PostInit_EventHandlers {
	foxLasersPostInit = "[] execVM '\foxLasers\init.sqf'";
};

class foxConfig {
	#include "\userconfig\foxLasers\settings.hpp"
};
