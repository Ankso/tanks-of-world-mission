/******************************************
 * CLIENT INITIALIZATION
 ******************************************/

execVM "client\CommunicationFunctions.sqf";

// Initialize markers
// Flags markers
{
	format ["marker%1", _x] setMarkerText format ["%1 [0/%2]", (STRING_OBJECTIVES_NAMES select _forEachIndex), MAX_PERCENTAGE_OPFOR];
	format ["marker%1Area", _x] setMarkerPos (getMarkerPos format ["marker%1", _x]);
	format ["marker%1Area", _x] setMarkerSize [MAX_CAPTURE_DISTANCE, MAX_CAPTURE_DISTANCE];
} forEach OBJECTIVES_NAMES;
// Tickets markers
"markerBluforTicketsText" setMarkerText format ["Tickets [%1/%2]", MAX_TEAM_TICKETS, MAX_TEAM_TICKETS];
"markerBluforTickets" setMarkerSize [MAX_TEAM_TICKETS, 100];
"markerBluforTicketsBorder" setMarkerSize [MAX_TEAM_TICKETS, 100];
"markerBluforTicketsBorder" setMarkerPos (getMarkerPos "markerBluforTickets");
"markerOpforTicketsText" setMarkerText format ["Tickets [%1/%2]", MAX_TEAM_TICKETS, MAX_TEAM_TICKETS];
"markerOpforTickets" setMarkerSize [MAX_TEAM_TICKETS, 100];
"markerOpforTicketsBorder" setMarkerSize [MAX_TEAM_TICKETS, 100];
"markerOpforTicketsBorder" setMarkerPos (getMarkerPos "markerOpforTickets");
// This position is used to move the markers to create a "loading bar" effect
initialMarkerBluforTicketsPos = getMarkerPos "markerBluforTickets";
initialMarkerOpforTicketsPos = getMarkerPos "markerOpforTickets";