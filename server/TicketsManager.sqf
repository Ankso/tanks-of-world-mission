while {true} do
{
	// Just get the number of controlled points for each side and deduct 1 ticket per enemy controlled flag.
	_opforObjectivesCount = 0;
	_bluforObjectivesCount = 0;
	_opforTickets = teamTickets select SIDE_OPFOR;
	_bluforTickets = teamTickets select SIDE_BLUFOR;
	{
		if (_x == OBJECTIVE_OPFOR_CONTROLLED) then {
			_opforObjectivesCount = _opforObjectivesCount + 1;
		};
		if (_x == OBJECTIVE_BLUFOR_CONTROLLED) then {
			_bluforObjectivesCount = _bluforObjectivesCount + 1;
		};
	} forEach objectivesControl;
	teamTickets = [(_bluforTickets - _opforObjectivesCount), (_opforTickets - _bluforObjectivesCount)];
	// Update client. JIP is no problem with this.
	[OPCODE_UPDATE_TICKETS, teamTickets] call Sgc_FNC_BroadcastOpcode;
	/*
	if ((teamTickets select SIDE_BLUFOR) == (MAX_TEAM_TICKETS / 2) || (teamTickets select SIDE_BLUFOR) == (MAX_TEAM_TICKETS / 4) || (teamTickets select SIDE_BLUFOR) == (MAX_TEAM_TICKETS / 10)) then {
		[OPCODE_ADVERT, [SIDE_BLUFOR, format [STRING_TICKETS_LEFT, (teamTickets select SIDE_BLUFOR)]]] call Sgc_FNC_BroadcastOpcode;
	};
	if ((teamTickets select SIDE_OPFOR) == (MAX_TEAM_TICKETS / 2) || (teamTickets select SIDE_OPFOR) == (MAX_TEAM_TICKETS / 4) || (teamTickets select SIDE_OPFOR) == (MAX_TEAM_TICKETS / 10)) then {
		[OPCODE_ADVERT, [SIDE_OPFOR, format [STRING_TICKETS_LEFT, (teamTickets select SIDE_OPFOR)]]] call Sgc_FNC_BroadcastOpcode;
	};
	*/
	// Uncomment this line for debug
	// [OPCODE_MESSAGE, format ["Tickets remaining: %1", teamTickets]] call Sgc_FNC_BroadcastOpcode;
	sleep 5;
};