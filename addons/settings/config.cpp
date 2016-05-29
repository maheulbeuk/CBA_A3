#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"CBA_common", "A3_UI_F", "3DEN"};
        version = VERSION;
        author[] = {"commy2"};
        authorUrl = "https://github.com/CBATeam/CBA_A3";
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"

#include "Cfg3DEN.hpp"
#include "Display3DEN.hpp"

#include "CBA_Settings.hpp"
#include "gui\gui.hpp"
