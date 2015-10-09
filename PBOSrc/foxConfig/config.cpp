class CfgPatches {
	class foxConfig {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
	};
};

class foxConfig {
	#define true 1
	#define false 0
	#include "\userconfig\foxConfig\settings.hpp"
};
