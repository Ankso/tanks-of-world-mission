Sgc_FNC_HandleOpcode = {
	_opcode = _this select 0;
	_params = _this select 1;

	switch (_opcode) do {
		case OPCODE_NONE: {
			Diag_log "SGC_DEBUG_ERROR: Called unused opcode OPCODE_NONE.";
		};
		case OPCODE_DEBUG: {
			_params call Sgc_FNC_DebugLog;
		};
		case OPCODE_HINT: {
			_params call Sgc_FNC_SendHint;
		};
		case OPCODE_MESSAGE: {
			_params call Sgc_FNC_SendMessage;
		};
		case OPCODE_ADVERT: {
			_params call Sgc_FNC_SendAdvert;
		};
		case OPCODE_UPDATE_MARKERS: {
			_params call Sgc_FNC_UpdateMarkers;
		};
		case OPCODE_UPDATE_TICKETS: {
			_params call Sgc_FNC_UpdateTickets;
		};
		case OPCODE_END_MISSION: {
			_params call Sgc_FNC_EndMission;
		};
		default { Diag_log format ["SGC_DEBUG_ERROR: Received invalid opcode: %1, with params: %2.", _opcode, _params]; };
	};
};

Sgc_FNC_DebugLog = {
	_message = _this select 0;
	if (side player == East) then {
		[East, "HQ"] sideChat format ["SGC_DEBUG_LOG: %1", _message];
	} else {
		[West, "airbase"] sideChat format ["SGC_DEBUG_LOG: %1", _message];
	};
	Diag_log format ["SGC_DEBUG_LOG: %1", _message];
};

Sgc_FNC_SendHint = {
	hint _this;
};

Sgc_FNC_SendMessage = {
	if (side player == East) then {
		[East, "HQ"] sideChat format ["%1", _this];
	} else {
		[West, "airbase"] sideChat format ["%1", _this];
	};
};

Sgc_FNC_SendAdvert = {
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

Sgc_FNC_UpdateMarkers = {
	{
		// Set marker color
		if (_x == 0) then {
			format ["marker%1", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorGreen";
			format ["marker%1Area", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorGreen";
		};
		if (_x > 0) then {
			format ["marker%1", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorRed";
			format ["marker%1Area", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorRed";
		};
		if (_x < 0) then {
			format ["marker%1", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorBlue";
			format ["marker%1Area", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerColor "ColorBlue";
		};
		// Show positive number also with allies
		// We can safely change the _x value as this is only used once client side
		if (_x < 0) then {
			_x = _x * -1;
		};
		format ["marker%1", (OBJECTIVES_NAMES select _forEachIndex)] setMarkerText format ["%1 [%2/%3]", (STRING_OBJECTIVES_NAMES select _forEachIndex), _x, MAX_PERCENTAGE_OPFOR];
	} forEach _this;
};

Sgc_FNC_UpdateTickets = {
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

Sgc_FNC_EndMission = {
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