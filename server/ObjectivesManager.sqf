/*
 * This scripts keeps checking the player's distance to the 5 objectives during all the mission.
 * If a player is within MAX_CAPTURE_DISTANCE from an objective, this script will activate the
 * required procedures to start capturing it.
 *
 * @author [SGC] Ankso
 */

while {true} do
{
    
    // Check if any player has entered the conquest area of any objective.
    {
        for [{_i = 0}, {_i < OBJECTIVES_COUNT}, {_i = _i + 1}] do
        {
            if (((objectivesPositions select _i) distance _x) <= MAX_CAPTURE_DISTANCE && vehicle _x != _x) then
            {
                // If the player is within the distance of a point, push him into the array.
                // But check if the player is already in the array before that!
                if (!(_x in (objectivesPlayers select _i))) then
                {
                    (objectivesPlayers select _i) set [count (objectivesPlayers select _i), _x];
                    // We can break the loop and save CPU, obviously a player can't be taking two objectives at a time.
                    _i = OBJECTIVES_COUNT + 1;
                };
            };
        };
    } forEach playableUnits; // Note that this returns [] in local, use onlinePlayers and uncomment the debug code in Init.sqf,
                             // and make sure that you use a unit named player1.
    // Now check if any player has left the conquest area of any objective, or if his vehicle has been destroyed.
    for [{_i = 0}, {_i < OBJECTIVES_COUNT}, {_i = _i + 1}] do
    {
        {
            if (((objectivesPositions select _i) distance _x) > MAX_CAPTURE_DISTANCE || vehicle _x == _x) then
            {
                _tempArray = [];
                for [{_j = 0}, {_j < count (objectivesPlayers select _i)}, {_j = _j + 1}] do
                {
                    if (((objectivesPlayers select _i) select _j) != _x) then
                    {
                        _tempArray set [count _tempArray, ((objectivesPlayers select _i) select _j)];
                    };
                };
                objectivesPlayers set [_i, _tempArray];
            };
        } forEach (objectivesPlayers select _i);
    };
    // Finally make the operations with the status arrays. CaptureManager.sqf will do the rest.
    for [{_i = 0}, {_i < OBJECTIVES_COUNT}, {_i = _i + 1}] do
    {
        if (count (objectivesPlayers select _i) == 0) then
        {
            if ((objectivesStatus select _i) != STATUS_NOT_ATTACKED) then
            {
                objectivesStatus set [_i, STATUS_NOT_ATTACKED];
                // Update the client
                [OPCODE_UPDATE_STATUS, objectivesStatus] call SGC_fnc_BroadcastOpcode;
            };
        }
        else
        {
            _opforCount = 0;
            _bluforCount = 0;
            {
                if (side _x == West) then
                {
                    _bluforCount = _bluforCount + 1;
                }
                else
                {
                    _opforCount = _opforCount + 1;
                };
            } forEach (objectivesPlayers select _i);
            if (_opforCount == _bluforCount) then
            {
                objectivesStatus set [_i, STATUS_TIE_ATTACKED];
                [OPCODE_UPDATE_STATUS, objectivesStatus] call SGC_fnc_BroadcastOpcode;
            }
            else
            {
                if (_opforCount > _bluforCount) then
                {
                    // Broadcast "Under attack" message only if it wasn't previously under attack and the attacker is not the owner
                    if ((objectivesStatus select _i) != STATUS_UNDER_OPFOR_ATTACK && ((objectivesControl select _i) == OBJECTIVE_BLUFOR_CONTROLLED || (objectivesControl select _i) == OBJECTIVE_NOT_CONTROLLED)) then {
                        [OPCODE_ADVERT, [SIDE_BLUFOR, format [STRING_OBJECTIVE_UNDER_ATTACK, (STRING_OBJECTIVES_NAMES select _i)]]] call SGC_fnc_BroadcastOpcode;
                        [OPCODE_ADVERT, [SIDE_OPFOR, format [STRING_ATTACKING_OBJECTIVE, (STRING_OBJECTIVES_NAMES select _i)]]] call SGC_fnc_BroadcastOpcode;
                        objectivesStatus set [_i, STATUS_UNDER_OPFOR_ATTACK];
                        // Update the client
                        [OPCODE_UPDATE_STATUS, objectivesStatus] call SGC_fnc_BroadcastOpcode;
                    };
                }
                else
                {
                    if ((objectivesStatus select _i) != STATUS_UNDER_BLUFOR_ATTACK && ((objectivesControl select _i) == OBJECTIVE_OPFOR_CONTROLLED || (objectivesControl select _i) == OBJECTIVE_NOT_CONTROLLED)) then {
                        [OPCODE_ADVERT, [SIDE_OPFOR, format [STRING_OBJECTIVE_UNDER_ATTACK, (STRING_OBJECTIVES_NAMES select _i)]]] call SGC_fnc_BroadcastOpcode;
                        [OPCODE_ADVERT, [SIDE_BLUFOR, format [STRING_ATTACKING_OBJECTIVE, (STRING_OBJECTIVES_NAMES select _i)]]] call SGC_fnc_BroadcastOpcode;
                        objectivesStatus set [_i, STATUS_UNDER_BLUFOR_ATTACK];
                        [OPCODE_UPDATE_STATUS, objectivesStatus] call SGC_fnc_BroadcastOpcode;
                    };
                };
            };
        };
    };
    // 0.95 + time executing the script is aprox 1 second.
    sleep 0.95;
};