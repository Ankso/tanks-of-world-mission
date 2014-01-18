while {true} do
{
    {
        if (_x == STATUS_UNDER_OPFOR_ATTACK) then
        {
            if ((clientObjectivesPercentage select _forEachIndex) < MAX_PERCENTAGE_OPFOR) then
            {
                clientObjectivesPercentage set [_forEachIndex, (clientObjectivesPercentage select _forEachIndex) + 1];
            };
        };
        if (_x == STATUS_UNDER_BLUFOR_ATTACK) then
        {
            if ((clientObjectivesPercentage select _forEachIndex) > MAX_PERCENTAGE_BLUFOR) then
            {
                clientObjectivesPercentage set [_forEachIndex, (clientObjectivesPercentage select _forEachIndex) - 1];
            };
        };
        if (_x == STATUS_NOT_ATTACKED && !((clientObjectivesPercentage select _forEachIndex) == MAX_PERCENTAGE_OPFOR || (clientObjectivesPercentage select _forEachIndex) == MAX_PERCENTAGE_BLUFOR)) then
        {
            if ((clientObjectivesPercentage select _forEachIndex) < 0) then
            {
                clientObjectivesPercentage set [_forEachIndex, (clientObjectivesPercentage select _forEachIndex) + 1];
            };
            if ((clientObjectivesPercentage select _forEachIndex) > 0) then
            {
                clientObjectivesPercentage set [_forEachIndex, (clientObjectivesPercentage select _forEachIndex) - 1];
            };
        };
    } forEach clientObjectivesStatus;
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
	} forEach clientObjectivesPercentage;
    // Script execution time is negligible here
    sleep 1;
};