_timeRemaining = MAX_GAME_DURATION;

while {true} do
{
	_opforWins = true;
	_bluforWins = true;
	_isTie = false;
	_opforCount = 0;
	_bluforCount = 0;
	// Check if one of the teams owns all the objectives.
	{
		if (_x == OBJECTIVE_OPFOR_CONTROLLED) then {
			_bluforWins = false;
			_opforCount = _opforCount + 1;
		};
		if (_x == OBJECTIVE_BLUFOR_CONTROLLED) then {
			_opforWins = false;
			_bluforCount = _bluforCount + 1;
		};
		if (_x == OBJECTIVE_NOT_CONTROLLED) then {
			_opforWins = false;
			_bluforWins = false;
		};
	} forEach objectivesControl;
	// Check if one (or both :D) team has no tickets left
	if ((teamTickets select SIDE_OPFOR) < 1) then {
		_bluforWins = true;
	};
	if ((teamTickets select SIDE_BLUFOR) < 1) then {
		_opforWins = true;
	};
	if ((teamTickets select SIDE_BLUFOR) < 1 && (teamTickets select SIDE_OPFOR) < 1) then {
		_opforWins = false;
		_bluforWins = false;
		_isTie = true;
	};
	// Check if maximun game time has expired
	_timeRemaining = _timeRemaining - 1;
	if (_timeRemaining <= 0 && !_opforWins && !_bluforWins) then {
		if ((teamTickets select SIDE_OPFOR) > (teamTickets select SIDE_BLUFOR)) then {
			_bluforWins = false;
		};
		if ((teamTickets select SIDE_BLUFOR) > (teamTickets select SIDE_OPFOR)) then {
			_opforWins = false;
		};
		if ((teamTickets select SIDE_BLUFOR) == (teamTickets select SIDE_OPFOR)) then {
			_isTie = true;
		};
	};
	// Now end the game if needed.
	if (_opforWins) then
	{
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_WIN_MESSAGE, STRING_OPFOR]]] call Sgc_FNC_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_OPFOR] call Sgc_FNC_BroadcastOpcode;
		sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	if (_bluforWins) then
	{
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_WIN_MESSAGE, STRING_BLUFOR]]] call Sgc_FNC_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_BLUFOR] call Sgc_FNC_BroadcastOpcode;
	    sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	if (_isTie) then {
		[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_TIE_MESSAGE]]] call Sgc_FNC_BroadcastOpcode;
		[OPCODE_END_MISSION, SIDE_BOTH] call Sgc_FNC_BroadcastOpcode;
		sleep 5;
		[nil,nil,rENDMISSION,"End1"] call RE;
		endMission "END1";
	};
	// Send messages to players with the time left every 10 minutes
	if (_timeRemaining == 1800 || _timeRemaining == 900 || _timeRemaining == 600 || _timeRemaining == 300) then {
		[OPCODE_MESSAGE, format [STRING_TIME_REMAINING, (_timeRemaining / 60)]] call Sgc_FNC_BroadcastOpcode;
	};
	// Uncomment this for debugging
	// [OPCODE_MESSAGE, format ["OPFOR: %1, BLUFOR: %2, OPFOR wins: %3, BLUFOR wins: %4, Time remaining: %5.", _opforCount, _bluforCount, _opforWins, _bluforWins, _timeRemaining]] call Sgc_FNC_BroadcastOpcode;
	sleep 1;
};