/******************************************
 * Steel Gamers Tanks of World v1.1.3
 * WWII Tanks engage a fierce battle for the control of 5 key objectives.
 * 
 * SHARED INITIALIZATION
 *
 * @author [SGC] Ankso
 * @url http://www.steelgamers.es
 ******************************************/

execVM "shared\SharedDefines.sqf";
execVM "shared\Strings.sqf";
// Client initialization
execVM "client\init.sqf";

waitUntil{!(isNil "BIS_MPF_InitDone")};

// Server initialization.
if (isServer) then {
	execVM "server\Init.sqf";
};