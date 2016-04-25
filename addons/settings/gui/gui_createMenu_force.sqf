
private _ctrlSettingForce = _display ctrlCreate ["RscCheckBox", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSettingForce ctrlSetPosition [
    POS_X(33),
    POS_Y(uiNamespace getVariable OFFSETY(_addon,_source)),
    POS_X(1),
    POS_Y(1)
];
_ctrlSettingForce ctrlCommit 0;
_ctrlSettingForce cbSetChecked ([_setting, _source] call FUNC(isForced));

_settingsControlsInfo pushBack [_linkedControls, _setting, _source];

_ctrlSettingForce ctrlAddEventHandler ["CheckedChanged", {
    params ["_control", "_state"];

    private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
    _settingsControlsInfo params ["", "_setting", "_source"];

    SET_TEMP_NAMESPACE_FORCED(_setting,_state == 1,_source);
}];

_linkedControls pushBack _ctrlSettingForce;

if !(_enabled) then {
    _ctrlSettingForce ctrlEnable false;
};
