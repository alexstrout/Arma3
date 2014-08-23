class CfgPatches {
	class foxLasers {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		version = "0.01";
		versionStr = "0.01";
		versionDesc= "Universal Virtual Arsenal + AI Tweaks";
		versionAr[] = {0,0,1};
		author[] = {"fox"};
	};
};

class CfgFunctions {
	class foxLasers {
		class foxLasersFnc {
			class init {
				file = "\foxLasers\init.sqf";
				postInit = 1;
				recompile = 1;
			};
		};
	};
};

class foxConfig {
	#include "\userconfig\foxLasers\settings.hpp"
};
