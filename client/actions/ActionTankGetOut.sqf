// See client/VehicleControlManager.sqf for more information

_this select 0 removeAction (_this select 2);
_this select 0 removeAction 1;
_this select 0 removeAction 2;
_this select 1 action ["GetOut", _this select 0];