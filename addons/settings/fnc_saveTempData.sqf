/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_saveTempData

Description:
    Saves temporary settings after closing the ingame settings editor.

Parameters:
    None

Returns:
    None

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

{
    private _setting = _x;

    {
        private _source = _x;

        if (toLower _setting in allVariables GET_TEMP_NAMESPACE(_source)) then {
            (GET_TEMP_NAMESPACE(_source) getVariable _setting) params ["_value", "_forced"];

            if (isNil "_value") then {
                _value = [_setting, _source] call FUNC(get);
            };

            if (isNil "_forced") then {
                _forced = [_setting, _source] call FUNC(isForced);
            };

            [_setting, _value, _forced, _source] call FUNC(set);
        };
    } forEach ["client", "server", "mission"];
} forEach GVAR(allSettings);
