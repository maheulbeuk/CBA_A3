/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_import

Description:
    Import all setting info.

Parameters:
    _info   - Formated settings info, (from CBA_settings_fnc_export), (optional, default: clipboard) <STRING>

Returns:
    true if successful, otherwise false <BOOLEAN>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_info", "", [""]], ["_source", "client", [""]]];

_info = _info call FUNC(parse);

diag_log text format ["[CBA] (settings): Importing settings..."];

{
    _x params ["_setting", "_value", "_force"];

    SET_TEMP_NAMESPACE_VALUE(_setting,_value,_source);
    SET_TEMP_NAMESPACE_FORCED(_setting,_force,_source);
} forEach _info;

call FUNC(saveTempData);

(uiNamespace getVariable [QGVAR(display), displayNull]) closeDisplay 0;
