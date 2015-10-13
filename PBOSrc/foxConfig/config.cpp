#define true 1
#define false 0

class CfgPatches {
	class foxConfig {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
	};
};

class foxConfig {
	#include "\userconfig\foxConfig\settings.hpp"
};
