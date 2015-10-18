#define true 1
#define false 0

class CfgPatches {
	class foxUVA {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class foxUVA {
		class foxUVAFnc {
			class init {
				file = "\foxUVA\init.sqf";
				postInit = 1;
				recompile = 1;
			};
		};
	};
};
