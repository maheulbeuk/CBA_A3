
#define SLIDER_TYPES ["CBA_Rsc_Slider_R", "CBA_Rsc_Slider_G", "CBA_Rsc_Slider_B"]
#define SLIDER_COLORS [[1,0,0,1], [0,1,0,1], [0,0,1,1], [1,1,1,1]]

private _ctrlSettingPreview = _display ctrlCreate ["RscText", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

_ctrlSettingPreview ctrlSetPosition [
    POS_X(9.5),
    POS_Y(_offsetY + 1.0),
    POS_X(6),
    POS_Y(1)
];
_ctrlSettingPreview ctrlCommit 0;

_currentValue params [
    ["_r", 0, [0]],
    ["_g", 0, [0]],
    ["_b", 0, [0]],
    ["_a", 1, [0]]
];
private _color = [_r, _g, _b, _a];
_ctrlSettingPreview ctrlSetBackgroundColor _color;

_linkedControls append [_ctrlSettingPreview, []];
_settingsControlsInfo pushBack [_linkedControls, _setting, _source, _currentValue, _color];

for "_index" from 0 to (((count _defaultValue max 3) min 4) - 1) do {
    private _ctrlSetting = _display ctrlCreate [SLIDER_TYPES param [_index, "RscXSliderH"], count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

    _ctrlSetting ctrlSetPosition [
        POS_X(16),
        POS_Y(_offsetY),
        POS_X(8),
        POS_Y(1)
    ];
    _ctrlSetting ctrlCommit 0;

    _ctrlSetting sliderSetRange [0, 1];
    _ctrlSetting sliderSetPosition (_currentValue param [_index, 0]);

    _settingsControlsInfo pushBack [_linkedControls, _setting, _source, _currentValue, _color, _index, _ctrlSettingPreview];

    _ctrlSetting ctrlAddEventHandler ["SliderPosChanged", {
        params ["_control", "_value"];

        private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
        _settingsControlsInfo params ["_linkedControls", "_setting", "_source", "_currentValue", "_color", "_index", "_ctrlSettingPreview"];

        private _linkedControl = _linkedControls select 1 select _index select 1;
        _linkedControl ctrlSetText ([_value, 1, 2] call (uiNamespace getVariable "CBA_fnc_formatNumber"));

        _currentValue set [_index, _value];
        _color set [_index, _value];
        _ctrlSettingPreview ctrlSetBackgroundColor _color;

        SET_TEMP_NAMESPACE_VALUE(_setting,_currentValue,_source);
    }];

    private _ctrlSettingEdit = _display ctrlCreate ["RscEdit", count _settingsControlsInfo + IDC_OFFSET_SETTING, _ctrlOptionsGroup];

    _ctrlSettingEdit ctrlSetPosition [
        POS_X(24),
        POS_Y(_offsetY),
        POS_X(2),
        POS_Y(1)
    ];
    _ctrlSettingEdit ctrlCommit 0;

    //_ctrlSettingEdit ctrlSetTextColor (SLIDER_COLORS param [_index, 0]);
    _ctrlSettingEdit ctrlSetActiveColor (SLIDER_COLORS param [_index, 0]);
    _ctrlSettingEdit ctrlSetText ([_currentValue param [_index, 0], 1, 2] call (uiNamespace getVariable "CBA_fnc_formatNumber"));

    _settingsControlsInfo pushBack [_linkedControls, _setting, _source, _currentValue, _color, _index, _ctrlSettingPreview];

    _ctrlSettingEdit ctrlAddEventHandler ["KeyUp", {
        params ["_control"];

        private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
        _settingsControlsInfo params ["_linkedControls", "_setting", "_source", "_currentValue", "_color", "_index", "_ctrlSettingPreview"];

        private _value = parseNumber ctrlText _control;

        private _linkedControl = _linkedControls select 1 select _index select 0;
        _linkedControl sliderSetPosition _value;

        _currentValue set [_index, sliderPosition _linkedControl];
        _color set [_index, _value];
        _ctrlSettingPreview ctrlSetBackgroundColor _color;

        SET_TEMP_NAMESPACE_VALUE(_setting,_currentValue,_source);
    }];

    _ctrlSettingEdit ctrlAddEventHandler ["KillFocus", {
        params ["_control"];

        private _settingsControlsInfo = (uiNamespace getVariable QGVAR(settingsControlsInfo)) select (ctrlIDC _control - IDC_OFFSET_SETTING);
        _settingsControlsInfo params ["_linkedControls", "", "", "", "", "_index"];

        private _linkedControl = _linkedControls select 1 select _index select 0;
        private _value = sliderPosition _linkedControl;

        _control ctrlSetText ([_value, 1, 2] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
    }];

    (_linkedControls select 1) pushBack [_ctrlSetting, _ctrlSettingEdit];

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

    _offsetY = _offsetY + 1.0;
};

_offsetY = _offsetY - 0.7;
