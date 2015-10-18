#define true 1
#define false 0

class CfgPatches {
	class foxAI {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class foxAI {
		class foxAIFnc {
			class init {
				file = "\foxAI\init.sqf";
				postInit = 1;
				recompile = 1;
			};
		};
	};
};
