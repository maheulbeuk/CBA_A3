/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_check

Description:
    Check if provided value is valid.

Parameters:
    _setting - Name of the setting <STRING>
    _value   - Value of to test <ANY>

Returns:
    All setting info. Additionally to being put into clipboard <BOOLEAN>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], "_value"];

if (isNil "_value") exitWith {false};

(GVAR(defaultSettings) getVariable _setting) params ["_defaultValue", "", "_settingType", "_values"];

switch (toUpper _settingType) do {
    case ("BOOLEAN"): {
        _value isEqualType false
    };
    case ("LIST"): {
        _value in _values
    };
    case ("SLIDER"): {
        _values params ["_min", "_max"];
        _value isEqualType 0 && {_value >= _min} && {_value <= _max}
    };
    case ("COLOR"): {
        _value isEqualType [] && {count _value == count _defaultValue} && {{_x < 0 || _x > 1} count _value == 0}
    };
    default {false};
};
