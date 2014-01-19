_this select 0 removeAction (_this select 2);
player action ["MoveToGunner", _this select 0];
_this select 0 addAction [STRING_GET_IN_COMMANDER, "client\actions\ActionGetInCommander.sqf", "", 0.2, false, true, "GetOver"];