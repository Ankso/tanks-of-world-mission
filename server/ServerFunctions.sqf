/*
 * Functions used only server side, mainly to broadcast packets to the client.
 * 
 * @author [SGC] Ankso
 */

SGC_fnc_BroadcastOpcode = {
	_opcode = _this select 0;
	_params = _this select 1;
	[nil, nil, rSPAWN, [_opcode, _params], { [(_this select 0), (_this select 1)] call SGC_fnc_HandleOpcode }] call RE;
};

SGC_fnc_DebugMessage = {
	_text = format ["%1", _this];
	[nil, nil, rSPAWN, [[East, "HQ"], _text], { (_this select 0) sideChat (_this select 1) }] call RE;
};

SGC_fnc_ChangeObjectiveFlag = {
	_newFlagClass = _this;
	deleteVehicle (objectivesFlags select _i);
	// It seems that this call is asymetric, so the old may not be deleted yet. Sleep 0.1 to ensure
	// that the new flag is spawned in the exact same position than the old one.
	sleep 0.1;
	objectivesFlags set [_i, (_newFlagClass createVehicle (objectivesPositions select _i))];
};