
private _ctrlSetting = _display ctrlCreate ["RscXSliderH", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSetting ctrlSetPosition [
    POS_X(16),
    POS_Y(_offsetY),
    POS_X(8),
    POS_Y(1)
];
_ctrlSetting ctrlCommit 0;

_ctrlSetting sliderSetRange _values;
_ctrlSetting sliderSetPosition _currentValue;

_settingsControlsInfo pushBack [_linkedControls, _setting, _source, _trailingDecimals];

_ctrlSetting ctrlAddEventHandler ["SliderPosChanged", {
    params ["_control", "_value"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["_linkedControls", "_setting", "_source", "_trailingDecimals"];

    private _linkedControl = _linkedControls select 1;
    _linkedControl ctrlSetText ([_value, 1, _trailingDecimals] call (uiNamespace getVariable "CBA_fnc_formatNumber"));

    SET_TEMP_NAMESPACE_VALUE(_setting,_value,_source);
}];

private _ctrlSettingEdit = _display ctrlCreate ["RscEdit", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSettingEdit ctrlSetPosition [
    POS_X(24),
    POS_Y(_offsetY),
    POS_X(2),
    POS_Y(1)
];
_ctrlSettingEdit ctrlCommit 0;
_ctrlSettingEdit ctrlSetText ([_currentValue, 1, _trailingDecimals] call (uiNamespace getVariable "CBA_fnc_formatNumber"));

_settingsControlsInfo pushBack [_linkedControls, _setting, _source, _trailingDecimals];

_ctrlSettingEdit ctrlAddEventHandler ["KeyUp", {
    params ["_control"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["_linkedControls", "_setting", "_source", "_trailingDecimals"];

    private _value = parseNumber ctrlText _control;

    private _linkedControl = _linkedControls select 0;
    _linkedControl sliderSetPosition _value;

    private _valueSlider = sliderPosition _linkedControl;

    SET_TEMP_NAMESPACE_VALUE(_setting,_valueSlider,_source);
}];

_ctrlSettingEdit ctrlAddEventHandler ["KillFocus", {
    params ["_control"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["_linkedControls", "", "", "_trailingDecimals"];

    private _linkedControl = _linkedControls select 0;
    private _value = sliderPosition _linkedControl;

    _control ctrlSetText ([_value, 1, _trailingDecimals] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
}];

_linkedControls append [_ctrlSetting, _ctrlSettingEdit];

if (_isOverwritten) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_OVERWRITTEN;
    _ctrlSetting ctrlSetTooltip localize LSTRING(overwritten_tooltip);
    _ctrlSettingEdit ctrlSetTooltip localize LSTRING(overwritten_tooltip);
};

if !(_enabled) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_DISABLED;
    _ctrlSetting ctrlEnable false;
    _ctrlSettingEdit ctrlEnable false;
};
