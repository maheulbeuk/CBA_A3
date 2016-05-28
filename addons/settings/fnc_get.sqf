/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_get

Description:
    Returns the value of a setting.

Parameters:
    _setting - Name of the setting <STRING>
    _source  - Can be "server", "mission", "client", "forced" or "default" (optional, default: "forced") <STRING>

Returns:
    Value of the setting <ANY>

Examples:
    (begin example)
        _result = "CBA_TestSetting" call CBA_settings_fnc_get
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], ["_source", "forced", [""]]];

private _value = switch (toLower _source) do {
    case ("client"): {
        (GVAR(clientSettings) getVariable _setting) param [0]
    };
    case ("server"): {
        (GVAR(serverSettings) getVariable _setting) param [0]
    };
    case ("mission"): {
        (GVAR(missionSettings) getVariable _setting) param [0]
    };
    case ("default"): {
        (GVAR(defaultSettings) getVariable _setting) param [0]
    };
    case ("forced"): {
        private "_value";

        {
            if ([_setting, _x] call FUNC(isForced)) exitWith {
                _value = [_setting, _x] call FUNC(get);
            };
        } forEach ["server", "mission", "client"];

        if (isNil "_value") then {nil} else {_value};
    };
    default {
        _source = "default"; // exit
    };
};

if (isNil "_value") exitWith {
    // setting does not seem to exist
    if (_source == "default") exitWith {nil};

    [_setting, "default"] call FUNC(get);
};

// copy array to prevent overwriting
if (_value isEqualType []) then {+_value} else {_value}
