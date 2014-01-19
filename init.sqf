/******************************************
 * Steel Gamers Tanks of World v1.1.6
 * WWII Tanks engage a fierce battle for the control of 5 key objectives.
 * 
 * MISSION INITIALIZATION
 *
 * @author [SGC] Ankso
 * @url http://www.steelgamers.es
 ******************************************/

// Shared initialization
_handle = [] execVM "shared\SharedDefines.sqf";
waitUntil { scriptDone _handle };
_handle = [] execVM "shared\Strings.sqf";
waitUntil { scriptDone _handle };

waitUntil{!(isNil "BIS_MPF_InitDone")};

// Server initialization.
if (isServer) then {
	_handle = [] execVM "server\Init.sqf";
};

// Client initialization.
if (!isDedicated) then {
    execVM "client\init.sqf";
};