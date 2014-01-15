/******************************************
 * SHARED INITIALIZATION
 ******************************************/

execVM "shared\SharedDefines.sqf";
execVM "shared\Strings.sqf";
execVM "client\init.sqf";

waitUntil{!(isNil "BIS_MPF_InitDone")};

// Server initialization.
if (isServer) then {
	execVM "server\Init.sqf";
};