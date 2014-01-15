/*
 * This script checks if the win conditions are meet, and then ends the game. Win conditions:
 *     - One team runs out of tickets.
 *     - Time is over.
 * 
 * @author [SGC] Ankso
 */

_timeRemaining = MAX_GAME_DURATION;

while {true} do
{
	_opforWins = false;
	_bluforWins = false;
	_isTie = false;
	_bluforTickets = teamTickets select SIDE_BLUFOR;
	_opforTickets = teamTickets select SIDE_OPFOR;
	// Check if one (or both :D) team has no tickets left
	if (_opforTickets < 1) then {
		_bluforWins = true;
	};
	if (_bluforTickets < 1) then {
		_opforWins = true;
	};
	if (_bluforTickets < 1 && _opforTickets < 1) then {
		_opforWins = false;
		_bluforWins = false;
		_isTie = true;
	};
	// Check if maximun game time has expired
	_timeRemaining = _timeRemaining - 1;
	if (_timeRemaining <= 0) then {
		if (_opforTickets < _bluforTickets) then {
			_bluforWins = true;
		};
		if (_bluforTickets < _opforTickets) then {
			_opforWins = true;
		};
		if (_bluforTickets == _opforTickets) then {
			_isTie = true;
		};
	};
	// Now end the game if needed.
	if (_opforWins) then
	{
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_WIN_MESSAGE, STRING_OPFOR]]] call SGC_fnc_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_OPFOR] call SGC_fnc_BroadcastOpcode;
		sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	if (_bluforWins) then
	{
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_WIN_MESSAGE, STRING_BLUFOR]]] call SGC_fnc_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_BLUFOR] call SGC_fnc_BroadcastOpcode;
	    sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	if (_isTie) then {
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_TIE_MESSAGE]]] call SGC_fnc_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_BOTH] call SGC_fnc_BroadcastOpcode;
		sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	// Send messages to players with the time left every 10 minutes
	if (_timeRemaining == 1800 || _timeRemaining == 900 || _timeRemaining == 600 || _timeRemaining == 300) then {
		[OPCODE_MESSAGE, format [STRING_TIME_REMAINING, (_timeRemaining / 60)]] call SGC_fnc_BroadcastOpcode;
	};
	// Uncomment this for debugging
	// [OPCODE_MESSAGE, format ["OPFOR: %1, BLUFOR: %2, OPFOR wins: %3, BLUFOR wins: %4, Time remaining: %5.", _opforCount, _bluforCount, _opforWins, _bluforWins, _timeRemaining]] call SGC_fnc_BroadcastOpcode;
	sleep 1;
};