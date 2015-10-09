class CfgPatches {
	class foxLasers {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
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
