#define COMPONENT settings
#include "\x\cba\addons\main\script_mod.hpp"
#include "\x\cba\addons\main\script_macros.hpp"

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

//#define DEBUG_ENABLED_SETTINGS

#ifdef DEBUG_ENABLED_SETTINGS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SETTINGS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SETTINGS
#endif

#define PATH_SETTINGS_FILE "userconfig\cba\settings.sqf"

#define IDC_ADDONS_GROUP 4301
#define IDC_BTN_CONFIGURE_ADDONS 4302
#define IDC_BTN_CLIENT 9000
#define IDC_BTN_SERVER 9001
#define IDC_BTN_MISSION 9002
#define IDC_BTN_IMPORT 9010
#define IDC_BTN_EXPORT 9011
#define IDC_TXT_FORCE 327
#define IDC_OFFSET_SETTING 10000

#define POS_X(N) ((N) * (((safezoneW / safezoneH) min 1.2) / 40))
#define POS_Y(N) ((N) * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))

#define OFFSETY(var1,var2) format [QGVAR(offsetY$%1$%2), var1, var2]

#define COLOR_TEXT_DISABLED [1,1,1,0.3]
#define COLOR_BUTTON_ENABLED [1,1,1,1]
#define COLOR_BUTTON_DISABLED [0,0,0,1]
#define COLOR_TEXT_OVERWRITTEN [1,0.3,0.3,1]

#define CAN_SET_CLIENT_SETTINGS (!isMultiplayer || {!isServer}) // in singleplayer or as client in multiplayer
#define CAN_SET_SERVER_SETTINGS (isMultiplayer && {isServer || serverCommandAvailable "#logout"}) // in multiplayer and host (local server) or admin (dedicated)
#define CAN_SET_MISSION_SETTINGS is3den // duh

#ifndef DEBUG_MODE_FULL
    #define CAN_VIEW_CLIENT_SETTINGS (!isMultiplayer || {!isServer}) // hide for local hosted MP client to not confuse
    #define CAN_VIEW_SERVER_SETTINGS isMultiplayer // everyone can peak at those in multiplayer
    #define CAN_VIEW_MISSION_SETTINGS (is3den || missionVersion >= 15) // can view those in 3den or 3den missions
#else
    #define CAN_VIEW_CLIENT_SETTINGS true
    #define CAN_VIEW_SERVER_SETTINGS true
    #define CAN_VIEW_MISSION_SETTINGS true
#endif

#define GET_TEMP_NAMESPACE(source) ([ARR_3(GVAR(clientSettingsTemp),GVAR(serverSettingsTemp),GVAR(missionSettingsTemp))] param [[ARR_3('client','server','mission')] find toLower source])
#define SET_TEMP_NAMESPACE_VALUE(setting,value,source)   GET_TEMP_NAMESPACE(source) setVariable [ARR_2(setting,[ARR_2(value,(GET_TEMP_NAMESPACE(source) getVariable setting) param [1])])]
#define SET_TEMP_NAMESPACE_FORCED(setting,forced,source) GET_TEMP_NAMESPACE(source) setVariable [ARR_2(setting,[ARR_2((GET_TEMP_NAMESPACE(source) getVariable setting) param [0],forced)])]

#define CLIENT_SETTING 1
#define SERVER_SERVER 2
#define MISSION_SERVER 4
