Vehicle Respawn Script (VRS) v0.8.2

Author: Bake
Repository: https://bitbucket.org/ArmaBake/vehicle-respawn-script


DESCRIPTION

VRS respawns destroyed and deserted vehicles efficiently.


FEATURES

- High efficiency (only one thread, adjustable check interval)
- Respawn times can be adjusted for each vehicle individually
- Supports limited respawns
- Init line support
- Optional wreck removal


INSTALLATION

Extract the "vehicleRespawn" folder into your mission's root folder
or any subfolder you want. Then add the following code to your init.sqf
file (create one if necessary): execVM "vehicleRespawn\init.sqf";

Finally, add this init line to each vehicle you want to respawn:

this setVariable ["bake_vrs_settings", [<time destroyed (minutes)>, <time deserted>,
<respawn limit (optional)>, <init line (optional)>]]

Example:
this setVariable ["bake_vrs_settings", [15, 45]]


CONFIGURATION

You can change default settings without modifying the original files
which makes updating them easier. To do that assign values to the
global variables defined at the top of vehicleRespawn\init.sqf
anywhere before initializing the script. Example:

BAKE_VRS_REMOVE_WRECKS = false;
execVM "vehicleRespawn\init.sqf";

This technique replaces parameters for better variant management in the upcoming
game mode this script was written for.


CHANGELOG

v0.8.2
- Stop server load from affecting respawn time

v0.8.1
- Fix incorrect path in README

v0.8
- First release


LICENSE

Do whatever you want.
