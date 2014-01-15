if (!isServer) exitWith {};

BAKE_VRS_REMOVE_WRECKS = missionNamespace getVariable ["BAKE_VRS_REMOVE_WRECKS", true];		// Should wrecks be removed?
BAKE_VRS_MIN_WRECK_DIST = missionNamespace getVariable ["BAKE_VRS_MIN_WRECK_DIST", 200];	// Always remove wrecks closer than this
BAKE_VRS_CHECK_INTERVAL = missionNamespace getVariable ["BAKE_VRS_CHECK_INTERVAL", 60];		// Time between checks in seconds

while {true} do
{
	{
		_settings = _x getVariable "bake_vrs_settings";
		
		if (!isNil "_settings") then
		{
			_curTime = diag_tickTime;
			_initialData = _x getVariable "bake_vrs_initialData";
			_respawnTimeDestroyed = 60 * (_settings select 0);
			_respawnTimeDeserted = 60 * (_settings select 1);
			_timeDestroyed = _x getVariable ["bake_vrs_timeDestroyed", _curTime];
			_timeDeserted = _x getVariable ["bake_vrs_timeDeserted", _curTime];
			
			if (isNil "_initialData") then
			{
				_initialData = [typeOf _x, getPosATL _x, getDir _x, fuel _x];
				_x setVariable ["bake_vrs_initialData", _initialData];
			};
			
			_type = _initialData select 0;
			_pos = _initialData select 1;
			
			if (canMove _x && _x getVariable ["ace_canmove", true]) then
			{
				_timeDestroyed = _curTime;
			};
			
			if (_x distance _pos < 5) then
			{
				_timeDeserted = _curTime;
			};
			
			if ({alive _x} count (crew _x) > 0) then
			{
				_timeDestroyed = _curTime;
				_timeDeserted = _curTime;
			};
			
			if ((_curTime - _timeDestroyed > _respawnTimeDestroyed || _curTime - _timeDeserted > _respawnTimeDeserted) &&
				{count ((_pos nearEntities ["AllVehicles", (sizeOf _type) / 2]) - [_x]) == 0}) then
			{
				_name = vehicleVarName _x;
				_numRespawns = if (count _settings > 2) then {_settings select 2} else {0};
				_timesRespawned = _x getVariable ["bake_vrs_timesRespawned", 1];
				
				_x setVariable ["bake_vrs_settings", nil];
				
				if (BAKE_VRS_REMOVE_WRECKS || damage _x < 1 || _x distance _pos < BAKE_VRS_MIN_WRECK_DIST) then
				{
					deleteVehicle _x;
				};
				
				_vehicle = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
				_vehicle setDir (_initialData select 2);
				_vehicle setFuel (_initialData select 3);
				
				// Process vehicle init
				if (count _settings > 3) then
				{
					_vehicle setVehicleInit (_settings select 3);
					processInitCommands;
				};
				
				// Set global name
				if (_name != "") then
				{
					_vehicle setVehicleInit format ["%1 = this; this setVehicleVarName '%1'", _name];
					processInitCommands;
				};
				
				if (_numRespawns <= 0 || _timesRespawned < _numRespawns) then
				{
					_vehicle setVariable ["bake_vrs_timesRespawned", _timesRespawned + 1];
					_vehicle setVariable ["bake_vrs_initialData", _initialData];
					_vehicle setVariable ["bake_vrs_settings", _settings];
				};
			}
			else
			{
				_x setVariable ["bake_vrs_timeDestroyed", _timeDestroyed];
				_x setVariable ["bake_vrs_timeDeserted", _timeDeserted];
			};
		};
	} forEach vehicles;
	
	sleep BAKE_VRS_CHECK_INTERVAL;
};
