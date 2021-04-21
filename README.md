# crackLockables
This will allow players to crack codes on doors, safes and lockboxes

* Discussion URL: None

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```
	
# Index:

* [Mission folder install](https://github.com/oiad/crackLockables#mission-folder-install)
* [dayz_server install](https://github.com/oiad/crackLockables#dayz_server-install)
* [BattlEye filter install](https://github.com/oiad/crackLockables#battleye-filter-install)
* [Old Releases](https://github.com/oiad/crackLockables#old-releases)

**[>> Download <<](https://github.com/oiad/crackLockables/archive/master.zip)**

# Install:

* This install basically assumes you have a custom variables.sqf, compiles.sqf and fn_selfActions.sqf.

** If not, visit this repo and follow the steps there**
https://github.com/AirwavesMan/custom-epoch-functions

# Mission folder install:

1. 	Open your fn_selfactions.sqf and search for:

	```sqf
	// ZSC
	if (Z_singleCurrency) then {
	```
	
	Add this code lines above:
	

	```sqf
	if (_hasHotwireKit && {((_typeOfCursorTarget in DZE_LockedStorage) && {_characterID != "0"}) || {_typeOfCursorTarget in DZE_DoorsLocked}}) then {
		if (s_crackLockables < 0) then {
			s_crackLockables = player addAction [format["<t color='#0059FF'>%1</t>",format [localize "STR_CL_CRL_CRACK",_text]],"scripts\crackLockables.sqf",_cursorTarget,0,false,true];
		};
	} else {
		player removeAction s_crackLockables;
		s_crackLockables = -1;
	};

	```

2. In fn_selfactions search for this codeblock:

	```sqf
	player removeAction s_bank_dialog3;
	s_bank_dialog3 = -1;
	player removeAction s_player_checkWallet;
	s_player_checkWallet = -1;	
	```	
	And add this below:
	
	```sqf
	player removeAction s_crackLockables;
	s_crackLockables = -1;	
	```
	
3. Open your variables.sqf and search for:

	```sqf
	s_bank_dialog3 = -1;
	s_player_checkWallet = -1;	
	```
	And add this below:
	
	```sqf
	s_crackLockables = -1;	
	```	

4. Copy the <code>scripts</code> folder from the repo to your mission folder.

5. This relies on my companion functions on my github [Here](https://github.com/oiad/scripts/tree/master/companionFunctions) and my <code>fnc_log</code> function [Here](https://github.com/oiad/scripts/tree/master/fnc_log)

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

1. In your config<yourServerName>\Battleye\publicVariable.txt on line 2: <code>5 !=remEx(Field|FP)</code> add this to the end of it:

	```sqf
	!=sk_crackLockables
	```

	So it will then look like this for example:

	```sqf
	5 !=remEx(Field|FP) <CUT> !=sk_crackLockables
	```

# Old Releases:	

**** *Epoch 1.0.6.2* ****
**[>> Download <<](https://github.com/oiad/crackLockables/archive/refs/tags/Epoch_1.0.6.2.zip)**