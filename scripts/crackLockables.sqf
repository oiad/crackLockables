/*
	crackLockables - Safe, Lockbox and Door cracking script by salival (https://github.com/oiad)
*/

if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_chance","_cursorTarget","_doorChance","_finished","_isDoor","_isLockBox","_isSafe","_isStorage","_lockBoxChance","_loopAmount","_safeChance","_type","_typeOf"];

_cursorTarget = _this select 3;
_typeOf = typeOf (_cursorTarget);

if (isNull _cursorTarget) exitWith {dayz_actionInProgress = false; systemChat "cursorTarget isNull!";};

_lockboxChance = 30; // % chance out of 100 for lockboxes to be cracked, set to 0 to disable.
_safeChance = 30; // % chance out of 100 for safe to be cracked, set to 0 to disable.
_doorChance = 30; // % chance out of 100 for door to be cracked, set to 0 to disable.
_loopAmount = 1; // How many times to run the animation?

_isSafe = _typeOf == "VaultStorageLocked";
_isLockBox = _typeOf == "LockBoxStorageLocked";
_isStorage = (_isSafe || _isLockBox);
_isDoor = _typeOf in DZE_DoorsLocked;
_type = "";

if !("ItemHotwireKit" in (magazines player)) exitWith {dayz_actionInProgress = false; systemChat localize "STR_CL_CRL_NEED";};
if ((!_isStorage && !_isDoor) || {_isDoor && ((_cursorTarget animationPhase "Open_hinge" == 1) || (_cursorTarget animationPhase "Open_latch" == 1))}) exitWith {dayz_actionInProgress = false; systemChat localize  "STR_CL_CRL_FAIL_UNLOCKED";};

switch (true) do {
	case _isSafe: {_chance = _safeChance; _type = [localize "STR_EPOCH_SAFE","Safe"];};
	case _isLockBox: {_chance = _lockBoxChance; _type = [localize "STR_EPOCH_LOCKBOX","LockBox"];};
	case _isDoor: {_chance = _doorChance; _type = [localize "str_dn_sounds_doors","Door"];};
};

if (_chance == 0) exitWith {dayz_actionInProgress = false; format localize ["STR_CL_CRL_FAIL_TYPE",_type select 0] call dayz_rollingMessages;};

player removeMagazine "ItemHotwireKit";

[player,"repair",0,false,100] call dayz_zombieSpeak;
_finished = ["Medic",_loopAmount] call fn_loopAction;
if (!_finished) exitWith {dayz_actionInProgress = false;[localize "STR_CL_CRL_FAIL_MOVE",1] call dayz_rollingMessages;};

if (_chance > random (100)) then {
	[localize "STR_CL_CRL_SUCCESS",1] call dayz_rollingMessages;

	if (_isStorage) then {dayz_combination = _cursorTarget getVariable ["CharacterID","0"];};

	sk_crackLockables = [player,_cursorTarget,dayz_authKey];
	publicVariableServer "sk_crackLockables";
} else {
	[localize "STR_CL_CRL_FAIL",1] call dayz_rollingMessages;
	["crackLockables",format ["%1 (%2) failed to open %3 @%4 %5 nearby: %6", dayz_playerName, dayz_playerUID, _type select 1, mapGridPosition _cursorTarget, getPosATL _cursorTarget, [player,600] call fnc_nearBy], true] call fnc_log;
};

dayz_actionInProgress = false;
