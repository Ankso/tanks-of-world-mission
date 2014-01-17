/*
 * One man tank control script adapted to ArmA 2 and this mission based on http://killzonekid.com/arma-scripting-tutorials-one-man-tank-operation/
 *
 * @author Killzone Kid
 * @url http://killzonekid.com/
 */

while {true} do {
    if (oneManCrew && (vehicle player) != player) then {
        _tank = vehicle player;
        _tank lockTurret [[0], true];
        _tank lockTurret [[0,0], true];
        _tank lockCargo true;
        _tank removeAllMPEventHandlers "MPKilled";
        enableSentences false;
        // _unit allowDamage false;
        // player action ["EngineOn", _tank];
        player action ["MoveToGunner", _tank];
        _tank lock true;
        _tank switchCamera "EXTERNAL";
        _tank addAction [localize "str_action_getout", "client\ActionTankGetOut.sqf", "", 0, false, true, "GetOver"];
        waitUntil {!isNull gunner _tank};
        _ai = createAgent [
            typeOf gunner _tank, [0,0,0], [], 0, "NONE"
        ];
        // _ai allowDamage false;
        _ai moveInDriver _tank;
        waitUntil {(vehicle player) == player || !(alive player)};
        deleteVehicle _ai;
        // _unit allowDamage true;
        player action ["EngineOff", _tank];
        _tank lock false;
        enableSentences true;
    };
    sleep 0.1;
};