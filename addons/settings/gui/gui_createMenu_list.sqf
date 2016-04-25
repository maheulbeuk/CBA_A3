
private _ctrlSetting = _display ctrlCreate ["RscCombo", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSetting ctrlSetPosition [
    POS_X(16),
    POS_Y(_offsetY),
    POS_X(10),
    POS_Y(1)
];
_ctrlSetting ctrlCommit 0;

private _data = [];

{
    private _index = _ctrlSetting lbAdd (_valueNames select _forEachIndex);
    _ctrlSetting lbSetData [_index, str _index];
    _data set [_index, _x];
} forEach _values;

_ctrlSetting lbSetCurSel (_values find _currentValue);

_settingsControlsInfo pushBack [_linkedControls, _setting, _source, _data];

_ctrlSetting ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_index"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["_linkedControls", "_setting", "_source", "_data"];

    private _value = _data select _index;
    SET_TEMP_NAMESPACE_VALUE(_setting,_value,_source);
}];

_linkedControls pushBack _ctrlSetting;

if (_isOverwritten) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_OVERWRITTEN;
    _ctrlSetting ctrlSetTooltip localize LSTRING(overwritten_tooltip);
};

if !(_enabled) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_DISABLED;
    _ctrlSetting ctrlEnable false;
};
