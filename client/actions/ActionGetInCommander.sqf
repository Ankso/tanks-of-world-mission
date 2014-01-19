_this select 0 removeAction (_this select 2);
player action ["MoveToCommander", _this select 0];
_this select 0 addAction [STRING_GET_IN_GUNNER, "client\actions\ActionGetInGunner.sqf", "", 0.2, false, true, "GetOver"];