/*
	crackLockables - Safe, Lockbox and Door cracking script by salival (https://github.com/oiad)
*/

if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_log","_isGate","_isFenceGate","_isNoTopGate","_isOpen","_chance","_cursorTarget","_doorChance","_finished","_isDoor","_isLockBox","_isSafe","_isStorage","_lockBoxChance","_loopAmount","_safeChance","_type","_typeOf"];

_cursorTarget = _this select 3;
_typeOf = typeOf _cursorTarget;

if (isNull _cursorTarget) exitWith {dayz_actionInProgress = false; systemChat localize "str_cursorTargetNotFound";};

_lockboxChance = 0.3; // 0.3 = 30% chance out of 100 for lockboxes to be cracked, set to 0 to disable.
_safeChance = 0.3; // 0.3 = 30% chance out of 100 for safe to be cracked, set to 0 to disable.
_doorChance = 0.3; // 0.3 = 30% chance out of 100 for door to be cracked, set to 0 to disable.
_loopAmount = 1; // How many times to run the animation?

_isSafe = _typeOf in ["VaultStorageLocked","VaultStorage2Locked","TallSafeLocked"];
_isLockBox = _typeOf in ["LockboxStorageLocked","LockboxStorage2Locked","LockboxStorageWinterLocked","LockboxStorageWinter2Locked"];
_isStorage = (_isSafe || _isLockBox);
_isDoor = _typeOf in DZE_DoorsLocked;
_type = "";
_isOpen = false;

if !("ItemHotwireKit" in (magazines player)) exitWith {dayz_actionInProgress = false; systemChat localize "STR_CL_CRL_NEED";};

_isFenceGate = ["WoodenGate_1_DZ","WoodenGate_2_DZ","WoodenGate_3_DZ","WoodenGate_4_DZ"];
_isNoTopGate = ["CinderGarageOpenTopLocked_DZ","Land_DZE_WoodOpenTopGarageLocked"];
_isGate = ["CinderGateLocked_DZ","Land_DZE_WoodGateLocked"];

if (_isDoor) then {
	_isOpen = call {
		if (_typeof in _isFenceGate) exitwith {
			(_cursorTarget animationPhase "DoorR" >= 0.5)
		};
		if (_typeof in _isNoTopGate) exitwith {
			(_cursorTarget animationPhase "doorl" >= 0.5)
		};	
		if (_typeof in _isGate) exitwith {
			(_cursorTarget animationPhase "Open_door" >= 0.5)	
		};
		(_cursorTarget animationPhase "Open_door" >= 0.5) 
	};
};

if ((!_isStorage && !_isDoor) || {_isDoor && _isOpen}) exitWith {dayz_actionInProgress = false; systemChat localize  "STR_CL_CRL_FAIL_UNLOCKED";};

call {
	if (_isSafe) exitWith {_chance = _safeChance; _type = [localize "STR_EPOCH_SAFE","Safe"];};
	if (_isLockBox) exitWith {_chance = _lockBoxChance; _type = [localize "STR_EPOCH_LOCKBOX","LockBox"];};
	if (_isDoor) exitWith {_chance = _doorChance; _type = [localize "str_dn_sounds_doors","Door"];};
};

if (_chance == 0) exitWith {dayz_actionInProgress = false; format localize ["STR_CL_CRL_FAIL_TYPE",_type select 0] call dayz_rollingMessages;};

player removeMagazine "ItemHotwireKit";

[player,(getPosATL player),100,"repair"] spawn fnc_alertZombies;
_finished = ["Medic",_loopAmount] call fn_loopAction;
if (!_finished) exitWith {player addMagazine "ItemHotwireKit"; dayz_actionInProgress = false;[localize "STR_CL_CRL_FAIL_MOVE",1] call dayz_rollingMessages;};

if ([_chance] call fn_chance) then {
	_code = _cursorTarget getVariable ["CharacterID","0"];
	
	if (_isStorage) then {	
		if (_isLockBox) then {
			[player,(getPosATL player),20,"lockboxopen"] spawn fnc_alertZombies;
		} else {
			[player,(getPosATL player),20,"safeopen"] spawn fnc_alertZombies;
		};
	
		PVDZE_handleSafeGear = [player,_cursorTarget,0,_code,dayz_authKey];
		publicVariableServer "PVDZE_handleSafeGear";

		waitUntil {!isNil "dze_waiting"};
	};	
	if (_isDoor) then {
		[player,(getPosATL player),20,"combo_unlock"] spawn fnc_alertZombies;
		
		call {
			if (_typeof in _isFenceGate) exitwith {
				_cursorTarget animate ["DoorR",1];
				_cursorTarget animate ["DoorL",1];
			};
			if (_typeof in _isNoTopGate) exitwith {
				_cursorTarget animate ["doorR",1];
				_cursorTarget animate ["doorl",1];
			};	
			if (_typeof in _isGate) exitwith {
				_cursorTarget animate ["Open_door",1];
				_cursorTarget animate ["Open_doorR",1];	
			};
			_cursorTarget animate ["Open_door",1];
		};		
		
		PVDZE_handleSafeGear = [player,_cursorTarget,5,_code];
		publicVariableServer "PVDZE_handleSafeGear";
	};

	[localize "STR_CL_CRL_SUCCESS",1] call dayz_rollingMessages;
	
	sk_crackLockables = [player,_cursorTarget,dayz_authKey];
	publicVariableServer "sk_crackLockables";
} else {
	[localize "STR_CL_CRL_FAIL",1] call dayz_rollingMessages;
};

dayz_actionInProgress = false;