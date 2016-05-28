/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_clear

Description:
    Clear all settings from profile or mission.

Parameters:
    _source  - Can be "client", "server" or "mission" (optional, default: "client") <STRING>

Returns:
    None

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_source", "client", [""]]];

switch (toLower _source) do {
    case ("client"): {
        profileNamespace setVariable [QGVAR(profileSettings), []];

        GVAR(clientSettings) call (uiNamespace getVariable "CBA_fnc_deleteNamespace");
        GVAR(clientSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
    };
    case ("server"): {
        if (isServer) then {
            GVAR(serverSettings) call (uiNamespace getVariable "CBA_fnc_deleteNamespace");
            GVAR(serverSettings) = isMultiplayer call (uiNamespace getVariable "CBA_fnc_createNamespace");
            publicVariable QGVAR(serverSettings);
        };
    };
    case ("mission"): {
        if (is3DEN) then {
            set3DENMissionAttributes [["Scenario", QGVAR(missionSettings), []]];
            GVAR(missionSettings) call (uiNamespace getVariable "CBA_fnc_deleteNamespace");
            GVAR(missionSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
        };
    };
    default {};
};

if (isServer) then {
    QGVAR(refreshAllSettings) call CBA_fnc_globalEvent;
} else {
    QGVAR(refreshAllSettings) call CBA_fnc_localEvent;
};

nil
