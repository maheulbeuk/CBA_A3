
private _ctrlSetting = _display ctrlCreate ["RscCheckBox", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSetting ctrlSetPosition [
    POS_X(16),
    POS_Y(_offsetY),
    POS_X(1),
    POS_Y(1)
];
_ctrlSetting ctrlCommit 0;
_ctrlSetting cbSetChecked _currentValue;

_settingsControlsInfo pushBack [_linkedControls, _setting, _source];

_ctrlSetting ctrlAddEventHandler ["CheckedChanged", {
    params ["_control", "_state"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["_linkedControls", "_setting", "_source"];

    private _value = _state == 1;
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
