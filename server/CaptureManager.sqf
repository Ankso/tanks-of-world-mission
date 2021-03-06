/*
 * This script updates the capture status of the different objectives.
 * 
 * @author [SGC] Ankso
 */

while {true} do
{
	_sendUpdateMarkers = false;
	// Iterate throught all the capture points
	for [{_i = 0}, {_i < OBJECTIVES_COUNT}, {_i = _i + 1}] do
	{
		// Check if capture point is being attacked
		if ((objectivesStatus select _i) != STATUS_NOT_ATTACKED) then
		{
			if ((objectivesStatus select _i) == STATUS_UNDER_OPFOR_ATTACK) then 
			{
				// If the objective is being taken by OPFOR add 1 point each second...
				if ((objectivesPercentage select _i) < MAX_PERCENTAGE_OPFOR) then {
					objectivesPercentage set [_i, (objectivesPercentage select _i) + 1];
                    _sendUpdateMarkers = true;
				};
			}
			else
			{
				// ...else deduct 1 point.
				if ((objectivesPercentage select _i) > MAX_PERCENTAGE_BLUFOR) then {
					objectivesPercentage set [_i, (objectivesPercentage select _i) - 1];
                    _sendUpdateMarkers = true;
				};
			};
		};
		// If the objective isn't being attacked AND isn't controlled, reset it progressively
		if (((objectivesStatus select _i) == STATUS_NOT_ATTACKED) && ((objectivesPercentage select _i > 0 && objectivesPercentage select _i < MAX_PERCENTAGE_OPFOR) || (objectivesPercentage select _i < 0 && objectivesPercentage select _i > MAX_PERCENTAGE_BLUFOR))) then
		{
			if ((objectivesPercentage select _i) > 0) then
			{
				objectivesPercentage set [_i, (objectivesPercentage select _i) - 1];
                _sendUpdateMarkers = true;
			};
			if ((objectivesPercentage select _i) < 0) then
			{
				objectivesPercentage set [_i, (objectivesPercentage select _i) + 1];
                _sendUpdateMarkers = true;
			};
		};
		// And finally, if the counter reachs MAX_PERCENTAGE_OPFOR or MAX_PERCENTAGE_BLUFOR, capture the point (if it hasn't been captured yet)
		// or if it reachs 0, set the objective as neutral.
		if (((objectivesPercentage select _i) == MAX_PERCENTAGE_OPFOR) && ((objectivesControl select _i) != OBJECTIVE_OPFOR_CONTROLLED)) then
		{
			objectivesControl set [_i, OBJECTIVE_OPFOR_CONTROLLED];
            // Update the status of the objective, as it isn't under attack anymore.
            objectivesStatus set [_i, STATUS_NOT_ATTACKED];
            // Send "objective taken" message 
			[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_OBJECTIVE_TAKEN, (STRING_OBJECTIVES_NAMES select _i), STRING_OPFOR]]] call SGC_fnc_BroadcastOpcode;
			// Delete old flag and create a new one
			// A function is needed because we need an asymetric call to stop 0.1 seconds between deleting the old flag and creating the new one.
			// Like this, the main script keeps it's 1 second check time.
			FLAG_CLASSNAME_OPFOR call SGC_fnc_ChangeObjectiveFlag;
		};
		if (((objectivesPercentage select _i) == MAX_PERCENTAGE_BLUFOR) && ((objectivesControl select _i) != OBJECTIVE_BLUFOR_CONTROLLED)) then
		{
			objectivesControl set [_i, OBJECTIVE_BLUFOR_CONTROLLED];
            objectivesStatus set [_i, STATUS_NOT_ATTACKED];
			[OPCODE_ADVERT, [SIDE_BOTH, format [STRING_OBJECTIVE_TAKEN, (STRING_OBJECTIVES_NAMES select _i), STRING_BLUFOR]]] call SGC_fnc_BroadcastOpcode;
			FLAG_CLASSNAME_BLUFOR call SGC_fnc_ChangeObjectiveFlag;
		};
		if ((objectivesPercentage select _i) == 0 && (objectivesControl select _i) != OBJECTIVE_NOT_CONTROLLED) then
		{
			objectivesControl set [_i, OBJECTIVE_NOT_CONTROLLED];
            // We don't need to update the status here, as this can only happen if the objective is not being attacked.
			FLAG_CLASSNAME_NEUTRAL call SGC_fnc_ChangeObjectiveFlag;
		};
	};
	// Update the client markers if needed
	if (_sendUpdateMarkers) then {
		[OPCODE_UPDATE_MARKERS, objectivesPercentage] call SGC_fnc_BroadcastOpcode;
	};
	// You can uncomment this for debug.
	// [OPCODE_MESSAGE, format ["Status: %1, Percentages: %2, Players: %3, Control: %4", objectivesStatus, objectivesPercentage, objectivesPlayers, objectivesControl]] call SGC_fnc_BroadcastOpcode;
	sleep 0.95;
};