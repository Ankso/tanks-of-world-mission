/*
 * Shared definitions, of different variables used all over the mission, both server
 * side and client side.
 *
 * @author [SGC] Ankso
 */

/*
 * These are params can be changed to match your needs. However,
 * they'll have an important impact in the gameplay.
 */

// paramsArray doesn't exist in local, create some default values when testing
if (isNil "paramsArray") then {
	paramsArray = [100, 100, 1000, 1200];
 };
 
// In meters. Maximun distance within a player will start capturing a zone.
MAX_CAPTURE_DISTANCE   = paramsArray select 0;

// Objectives percentage max (Axis positive percentage, allies negative percentage). This is also the number of seconds required to take an objective.
MAX_PERCENTAGE_OPFOR   = paramsArray select 1;
MAX_PERCENTAGE_BLUFOR  = (paramsArray select 1) * -1;

// Max number of tickets each team will have
MAX_TEAM_TICKETS       = paramsArray select 2;

// In seconds. Maximun game duration if none of the teams manage to capture all the objectives.
MAX_GAME_DURATION      = paramsArray select 3;

// Flags classnames, you can change the teams flags here
FLAG_CLASSNAME_OPFOR   = "FlagCarrierOPFOR_EP1";
FLAG_CLASSNAME_BLUFOR  = "FlagCarrierUSA_EP1";
FLAG_CLASSNAME_NEUTRAL = "FlagPole_EP1";

/*
 * These variables are constants and they never should be changed. All constants
 * are going to be written in capital letters only.
 */

// Objectives
ALPHA   = 0;
BRAVO   = 1;
CHARLIE = 2;
DELTA   = 3;
ECO     = 4; // ECHO is a reserved word.
OBJECTIVES_COUNT = 5; // For use in loops

// Objectives names (used for markers logic Etc)
OBJECTIVES_NAMES = ["Alpha", "Bravo", "Charlie", "Delta", "Echo"];

// Objectives control status
OBJECTIVE_NOT_CONTROLLED    = 0;
OBJECTIVE_OPFOR_CONTROLLED  = 1;
OBJECTIVE_BLUFOR_CONTROLLED = 2;

// Objectives status
STATUS_NOT_ATTACKED        = 0;
STATUS_UNDER_OPFOR_ATTACK  = 1;
STATUS_UNDER_BLUFOR_ATTACK = 2;
STATUS_TIE_ATTACK          = 3; // When both teams have the same number of players inside a capture area.

// Opcodes used for server-client communication. This opcodes will "explain" the client what to do.
OPCODE_NONE           = 0;
OPCODE_DEBUG          = 1;
OPCODE_HINT           = 2;
OPCODE_MESSAGE        = 3;
OPCODE_ADVERT         = 4;
OPCODE_UPDATE_STATUS  = 5;
OPCODE_UPDATE_MARKERS = 6;
OPCODE_UPDATE_TICKETS = 7;
OPCODE_END_MISSION    = 8;

// Side enums, this is used to handle who receives a message
SIDE_BLUFOR = 0;
SIDE_OPFOR  = 1;
SIDE_BOTH   = 2;