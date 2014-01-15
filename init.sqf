/******************************************
 * Steel Gamers Tanks of World v1.1.3
 * WWII Tanks engage a fierce battle for the control of 5 key objectives.
 * 
 * SHARED INITIALIZATION
 *
 * @author [SGC] Ankso
 * @url http://www.steelgamers.es
 ******************************************/

_handle = [] execVM "shared\SharedDefines.sqf";
waitUntil { scriptDone _handle };
_handle = [] execVM "shared\Strings.sqf";
waitUntil { scriptDone _handle };
// Client initialization
execVM "client\init.sqf";

waitUntil{!(isNil "BIS_MPF_InitDone")};

// Server initialization.
if (isServer) then {
	execVM "server\Init.sqf";
};