# crackLockables
This will allow players to crack codes on doors, safes and lockboxes

* Discussion URL: None

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible.

**[>> Download <<](https://github.com/oiad/crackLockables/archive/master.zip)**

# Mission folder install:

1. In mission\dayz_code\compile\fn_selfActions.sqf find: <code>// All Traders</code> and add directly above:

	```sqf
	if (_hasHotwireKit && (((_typeOfCursorTarget in DZE_LockedStorage) && {_characterID != "0"}) || {_typeOfCursorTarget in DZE_DoorsLocked && {((_cursorTarget animationPhase "Open_hinge" == 0) && (_cursorTarget animationPhase "Open_latch" == 0))}})) then {
		if (s_crackLockables < 0) then {
			s_crackLockables = player addAction [format["<t color='#0059FF'>%1</t>",format [localize "STR_CL_CRL_CRACK",_text]],"scripts\crackLockables.sqf",_cursorTarget,0,false,true];
		};
	} else {
		player removeAction s_crackLockables;
		s_crackLockables = -1;
	};

	```

2. In mission\dayz_code\compile\fn_selfActions.sqf find: <code>	// Custom stuff below</code> and add directly below:
	```sqf
	player removeAction s_crackLockables;
	s_crackLockables = -1;
	```

3. In mission\dayz_code\init\variables.sqf find: <code>	// Custom below</code> and add directly below:
	```sqf
	s_crackLockables = -1;
	```

4. Copy the <code>scripts</code> folder from the repo to your mission folder.

5. This relies on my companion functions on my github [Here](https://github.com/oiad/scripts/tree/master/companionFunctions) and my <code>fnc_log</code> function [Here](https://github.com/oiad/scripts/tree/master/fnc_log)

6. Download the <code>stringTable.xml</code> file linked below from the [Community Localization GitHub](https://github.com/oiad/communityLocalizations) and copy it to your mission folder, it is a community based localization file and contains translations for major community mods including this one.

**[>> Download stringTable.xml <<](https://github.com/oiad/communityLocalizations/blob/master/stringTable.xml)**

# dayz_server install:

1. Copy the <code>dayz_server\compile\server_crackLockables.sqf</code> file from the repo to your <code>dayz_server\compile</code> folder

2. In your <code>dayz_server\init\server_functions.sqf</code> file, find this line:
	```sqf
	spawn_vehicles = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_vehicles.sqf";
	```
	Add the following after it:
	```sqf
	
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_crackLockables.sqf";
	```

# Battleye filters:

