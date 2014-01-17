// Simple script to cwitch between tank control modes

if (vehicle player == player) then {
    oneManCrew = !(oneManCrew);
    if (oneManCrew) then {
        STRING_ONE_MAN_CREW_ENABLED call SGC_fnc_SendMessage;
    } else {
        STRING_ONE_MAN_CREW_DISABLED call SGC_fnc_SendMessage;
    };
} else {
    STRING_ONE_MAN_CREW_LOCKED call SGC_fnc_SendMessage;
};