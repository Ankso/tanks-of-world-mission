/*
 * This functions are used for server-client communication. Basically, they update the client
 * when the server requires so.
 * 
 * @author [SGC] Ankso
 */

SGC_fnc_HandleOpcode = {
	_opcode = _this select 0;
	_params = _this select 1;

    // Uncomment this for debug
    // format ["Received opcode %1 with data: %2", _opcode, _params] call SGC_fnc_DebugLog;
	switch (_opcode) do {
		case OPCODE_NONE: {
			Diag_log "SGC_DEBUG_ERROR: Called unused opcode OPCODE_NONE.";
		};
		case OPCODE_DEBUG: {
			_params call SGC_fnc_DebugLog;
		};
		case OPCODE_HINT: {
			_params call SGC_fnc_SendHint;
		};
		case OPCODE_MESSAGE: {
			_params call SGC_fnc_SendMessage;
		};
		case OPCODE_ADVERT: {
			_params call SGC_fnc_SendAdvert;
		};
        case OPCODE_UPDATE_STATUS: {
            _params call SGC_fnc_UpdateStatus;
        };
		case OPCODE_UPDATE_MARKERS: {
			_params call SGC_fnc_UpdateMarkers;
		};
		case OPCODE_UPDATE_TICKETS: {
			_params call SGC_fnc_UpdateTickets;
		};
		case OPCODE_END_MISSION: {
			_params call SGC_fnc_EndMission;
		};
		default { Diag_log format ["SGC_DEBUG_ERROR: Received invalid opcode: %1, with params: %2.", _opcode, _params]; };
	};
};

SGC_fnc_DebugLog = {
	_message = _this;
	if (side player == East) then {
		[East, "HQ"] sideChat format ["SGC_DEBUG_LOG: %1", _message];
	} else {
		[West, "airbase"] sideChat format ["SGC_DEBUG_LOG: %1", _message];
	};
	Diag_log format ["SGC_DEBUG_LOG: %1", _message];
};

SGC_fnc_SendHint = {
	hint _this;
};

SGC_fnc_SendMessage = {
	if (side player == East) then {
		[East, "HQ"] sideChat format ["%1", _this];
	} else {
		[West, "airbase"] sideChat format ["%1", _this];
	};
};

SGC_fnc_SendAdvert = {
	_side = _this select 0;
	_message = _this select 1;
	_playerSide = SIDE_BOTH;
	if (side player == West) then {
		_playerSide = SIDE_BLUFOR;
	} else {
		_playerSide = SIDE_OPFOR;
	};
	if (_playerSide == _side || _side == SIDE_BOTH) then {
		cutText [_message, "PLAIN DOWN"];
	};
};

SGC_fnc_UpdateStatus = {
    // This syncs the objectives status with the server.
    clientObjectivesStatus = _this;
};

SGC_fnc_UpdateMarkers = {
    // This function can be called from the server to force syncronization.
	clientObjectivesPercentage = _this;
};

SGC_fnc_UpdateTickets = {
	_bluforTickets = _this select SIDE_BLUFOR;
	_opforTickets = _this select SIDE_OPFOR;
	if (_bluforTickets < 0) then {
		_bluforTickets = 0;
	};
	if (_opforTickets < 0 ) then {
		_opforTickets = 0;
	};
	if (_bluforTickets < MAX_TEAM_TICKETS) then {
		"markerBluforTicketsText" setMarkerText format ["Tickets [%1/%2]", _bluforTickets, MAX_TEAM_TICKETS];
		"markerBluforTickets" setMarkerSize [_bluforTickets, 100];
		"markerBluforTickets" setMarkerPos ([(initialMarkerBluforTicketsPos select 0) - (MAX_TEAM_TICKETS - _bluforTickets), (getMarkerPos "markerBluforTickets") select 1]);
	};
	if (_opforTickets < MAX_TEAM_TICKETS) then {
		"markerOpforTicketsText" setMarkerText format ["Tickets [%1/%2]", _opforTickets, MAX_TEAM_TICKETS];
		"markerOpforTickets" setMarkerSize [_opforTickets, 100];
		"markerOpforTickets" setMarkerPos ([(initialMarkerOpforTicketsPos select 0) - (MAX_TEAM_TICKETS - _opforTickets), (getMarkerPos "markerOpforTickets") select 1]);
	};
};

SGC_fnc_EndMission = {
	_winner = _this select 0;
	_playerSide = SIDE_BOTH;
	// End the mission as winner if that's so.
	if (side player == West) then {
		_playerSide = SIDE_BLUFOR;
	} else {
		_playerSide = SIDE_OPFOR;
	};
	if (_playerSide == _winner) then {
		player sideChat STRING_VICTORY;
	} else {
		player sideChat STRING_DEFEAT;
	};
};