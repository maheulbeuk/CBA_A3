
private _lists = [];

uiNamespace setVariable [QGVAR(settingsControlsInfo), []];

{
    uiNamespace setVariable [_x, nil];
} forEach (uiNamespace getVariable [QGVAR(offsets), []]);
uiNamespace setVariable [QGVAR(offsets), []];

{
    private _setting = _x;
    (GVAR(defaultSettings) getVariable _setting) params ["_defaultValue", "_addon", "_settingType", "_values", "_labels", "_displayName", "_tooltip", "_trailingDecimals"];

    private _addon = toLower _addon;
    //_addons pushBackUnique _addon;
    if !(_addon in _addons) then {_addons pushBack _addon};

    {
        private _source = toLower _x;
        private _currentValue = [_setting, _source] call FUNC(get);

        // ----- create or retrieve options "list" controls group
        private _list = [QGVAR(list), _addon, _source] joinString "$";

        private "_ctrlOptionsGroup";
        if !(_list in _lists) then {
            _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), -1, _display displayCtrl IDC_ADDONS_GROUP];
            _ctrlOptionsGroup ctrlEnable false;
            _ctrlOptionsGroup ctrlShow false;
            _lists pushBack _list;
            uiNamespace setVariable [_list, _ctrlOptionsGroup];
        } else {
            _ctrlOptionsGroup = uiNamespace getVariable _list;
        };

        private _offsetY = uiNamespace getVariable OFFSETY(_addon,_source);

        if (isNil "_offsetY") then {
            _offsetY = 0.3;
            uiNamespace setVariable [OFFSETY(_addon,_source), _offsetY];
            (uiNamespace getVariable QGVAR(offsets)) pushBack OFFSETY(_addon,_source);
        };

        // ----- create setting name text
        private _ctrlSettingName = _display ctrlCreate ["CBA_Rsc_SettingText", -1, _ctrlOptionsGroup];

        _ctrlSettingName ctrlSetText format ["%1:", _displayName];
        _ctrlSettingName ctrlSetTooltip _tooltip;
        _ctrlSettingName ctrlSetPosition [
            POS_X(1),
            POS_Y(_offsetY),
            POS_X(15),
            POS_Y(1)
        ];
        _ctrlSettingName ctrlCommit 0;

        // ----- check if setting can be altered
        private _enabled = switch (toLower _source) do {
            case ("client"): {
                CAN_SET_CLIENT_SETTINGS
            };
            case ("server"): {
                CAN_SET_SERVER_SETTINGS
            };
            case ("mission"): {
                CAN_SET_MISSION_SETTINGS
            };
        };

        // ----- check if altering setting would have no effect
        private _isOverwritten = [_setting, _source] call FUNC(isOverwritten);

        // ----- create setting changer control
        private _settingsControlsInfo = uiNamespace getVariable QGVAR(settingsControlsInfo);
        private _linkedControls = [];

        switch (toUpper _settingType) do {
        case ("BOOLEAN"): {
            #include "gui_createMenu_button.sqf"
        };
        case ("LIST"): {
            #include "gui_createMenu_list.sqf"
        };
        case ("SLIDER"): {
            #include "gui_createMenu_slider.sqf"
        };
        case ("COLOR"): {
            #include "gui_createMenu_color.sqf"
        };
        default {};
        };

        #include "gui_createMenu_default.sqf"

        // ----- handle "force" button
        if (_source != "client") then {
            #include "gui_createMenu_force.sqf"
        };

        uiNamespace setVariable [OFFSETY(_addon,_source), _offsetY + 1.4];
    } forEach ["client", "server", "mission"];
} forEach GVAR(allSettings);

uiNamespace setVariable [QGVAR(lists), _lists];
