/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_export

Description:
    Copy all setting info into clipboard.

Parameters:
    _source - Can be "client", "server" or "mission" (optional, default: "client") <STRING>

Returns:
    All setting info. Additionally to being put into clipboard <ARRAY>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

#define NEWLINE toString [10]
#define KEYWORD_FORCE "force"

params [["_source", "client", [""]]];

private _info = [];

{
    private _value = [_x, _source] call FUNC(get);
    private _forced = [_x, _source] call FUNC(isForced);

    _info pushBack [_x, _value, _forced];
} forEach GVAR(allSettings);

// get into readable format
private _formattedInfo = "";

{
    _x params ["_setting", "_value", "_forced"];
    _formattedInfo = _formattedInfo + (["", KEYWORD_FORCE + " "] select _forced) + _setting + " = " + format ["%1", _value] + ";" + NEWLINE;
} forEach _info;

copyToClipboard _formattedInfo;

_info
