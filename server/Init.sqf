/******************************************
 * SERVER INITIALIZATION
 * 
 * @author [SGC] Ankso
 ******************************************/

// Initialize server functions
_handle = [] execVM "server\ServerFunctions.sqf";
waitUntil {scriptDone _handle};

/*
 * Vars initialization. These aren't constants so they don't belong to SharedDefines.sqf
 */

// This array stores the control status of the objectives (see SharedDefines.sqf)
objectivesControl = [0, 0, 0, 0, 0]; // 0 = OBJECTIVE_NOT_CONTROLLED

// This array stores the combat status of the objectives (see SharedDefines.sqf)
objectivesStatus = [0, 0, 0, 0, 0]; // 0 = STATUS_NOT_ATTACKED

// This arrays store the players that are within the capture distance of each point.
objectivesPlayers = [[], [], [], [], []];

// % complete of a capture for each objective. When this reachs 100(%), the objective is captured.
objectivesPercentage = [0, 0, 0, 0, 0];
// Exact positions of the objectives, to check distance from. These are set in the editor.
objectivesPositions = [
	getMarkerPos "markerAlphaArea",
	getMarkerPos "markerBravoArea",
	getMarkerPos "markerCharlieArea",
	getMarkerPos "markerDeltaArea",
	getMarkerPos "markerEchoArea"
];
// For debug purposes on local machines use this instead of playableUnits.
// onlinePlayers = [player1];

// Initialize tickets counters
teamTickets = [MAX_TEAM_TICKETS, MAX_TEAM_TICKETS];

// Initialize flags
objectivesFlags = [];
{
	objectivesFlags set [(count objectivesFlags), (FLAG_CLASSNAME_NEUTRAL createVehicle _x)];
} forEach objectivesPositions;

/*
 * Scripts initilization.
 */

// Vehicle respawn script
// @author: Bake
// @url: https://bitbucket.org/ArmaBake/vehicle-respawn-script
execVM "server\vehicle_respawn\init.sqf";

execVM "server\ObjectivesManager.sqf";
execVM "server\CaptureManager.sqf";
execVM "server\TicketsManager.sqf";
execVM "server\CheckWinConditions.sqf";