/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_set

Description:
    Set the value of a setting.

Parameters:
    _setting - Name of the setting <STRING>
    _value   - Value of the setting <ANY>
    _forced  - Force setting? <BOOLEAN>
    _source  - Can be "client", "server" or "mission" (optional, default: "client") <STRING>

Returns:
    _success - Whether or not the provided value was valid <BOOLEAN>

Examples:
    (begin example)
        ["CBA_TestSetting", 1] call CBA_settings_fnc_set
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], "_value", ["_forced", nil, [false]], ["_source", "client", [""]]];

if (!isNil "_value" && {!([_setting, _value] call FUNC(check))}) exitWith {
    diag_log text format ["[CBA] (settings): Value %1 is invalid for setting %2.", _value, str _setting];
    false
};

if (isNil "_forced") then {
    _forced = [_setting, _source] call FUNC(isForced);
};

switch (toLower _source) do {
    case ("client"): {
        // flag is used for server settings exclusively, keep previous state
        _forced = [_setting, _source] call FUNC(isForced);

        GVAR(clientSettings) setVariable [_setting, [_value, _forced]];

        (profileNamespace getVariable [QGVAR(profileSettings), []]) params [["_clientSettings", []], ["_clientValues", []], ["_clientForced", []]];
        private _index = _clientSettings find toLower _setting;

        if (_index == -1) then {
            _index = count _clientSettings;
        };

        _clientSettings set [_index, toLower _setting];
        _clientValues set [_index, _value];
        _clientForced set [_index, _forced];

        profileNamespace setVariable [QGVAR(profileSettings), [_clientSettings, _clientValues, _clientForced]];
        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
    };
    case ("server"): {
        if (isMultiplayer) then {
            if (isServer) then {
                GVAR(serverSettings) setVariable [_setting, [_value, _forced], true];

                (profileNamespace getVariable [QGVAR(profileSettings), []]) params [["_serverSettings", []], ["_serverValues", []], ["_serverForced", []]];
                private _index = _serverSettings find toLower _setting;

                if (_index == -1) then {
                    _index = count _serverSettings;
                };

                _serverSettings set [_index, toLower _setting];
                _serverValues set [_index, _value];
                _serverForced set [_index, _forced];

                profileNamespace setVariable [QGVAR(profileSettings), [_serverSettings, _serverValues, _serverForced]];
                [QGVAR(refreshSetting), _setting] call CBA_fnc_globalEvent;
            } else {
                if (serverCommandAvailable "#logout") then {
                    [QGVAR(setSettingServer), [_setting, _value, _forced]] call CBA_fnc_serverEvent;
                };
            };
        };
    };
    case ("mission"): {
        if (is3DEN) then {
            GVAR(missionSettings) setVariable [_setting, [_value, _forced]];

            ("Scenario" get3DENMissionAttribute QGVAR(missionSettings)) params [["_missionSettings", []], ["_missionValues", []], ["_missionForced", []]];
            private _index = _missionSettings find toLower _setting;

            if (_index == -1) then {
                _index = count _missionSettings;
            };

            _missionSettings set [_index, toLower _setting];
            _missionValues set [_index, _value];
            _missionForced set [_index, _forced];

            set3DENMissionAttributes [["Scenario", QGVAR(missionSettings), [_missionSettings, _missionValues, _missionForced]]];
            [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
        };
    };
    default {};
};

true
