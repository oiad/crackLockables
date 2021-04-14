/*
	crackLockables - Safe, Lockbox and Door cracking script by salival (https://github.com/oiad)
*/

"SK_crackLockables"	addPublicVariableEventHandler {(_this select 1) call server_crackLockables};

server_crackLockables = {
	private ["_charID","_clientKey","_coins","_exitReason","_inventory","_isDoor","_isLockBox","_isSafe","_isStorage","_message","_name","_object","_objectID","_objectUID","_ownerPUID","_player","_playerUID","_plotOwner","_pos","_type","_typeOf"];

	if (count _this < 3) exitWith {diag_log "server_crackLockables error: Improper parameter format";};

	_player = _this select 0;
	_object = _this select 1;
	_clientKey = _this select 2;

	_typeOf = typeOf _object;

	_isSafe = _typeOf == "VaultStorageLocked";
	_isLockBox = _typeOf == "LockBoxStorageLocked";
	_isStorage = (_isSafe || _isLockBox);
	_isDoor = _typeOf in DZE_DoorsLocked;

	_pos = _object getVariable ["OEMPos",getPosATL _object];
	_charID = _object getVariable ["CharacterID","0"];
	_objectID = _object getVariable ["ObjectID","0"];
	_objectUID = _object getVariable ["ObjectUID","0"];
	_ownerPUID = _object getVariable ["ownerPUID","0"];
	_name = if (alive _player) then {name _player} else {"unknown player"};
	_playerUID = getPlayerUID _player;

	_type = switch (true) do {
		case _isSafe: {"Safe"};
		case _isLockBox: {"Lockbox"};
		case _isDoor: {"Door"};
	};

	if !(_isStorage || _isDoor) exitWith {diag_log "server_crackLockables called with invalid storage/door object!"};
	if (isNull _player) exitWith {diag_log "ERROR: server_crackLockables called with Null player object";};
	if (isNull _object) exitWith {diag_log format["ERROR: server_crackLockables called with Null object by %1 (%2).",_name,_playerUID];};

	_exitReason = [_this,"crackLockables",_pos,_clientKey,_playerUID,_player] call server_verifySender;
	if (_exitReason != "") exitWith {diag_log _exitReason};

	_plotOwner = _player call fnc_nearPlot;
	if (_isStorage) then {
		_inventory = format ["inventory: %1",[_object getVariable ["WeaponCargo",[]], _object getVariable ["MagazineCargo",[]], _object getVariable ["BackpackCargo",[]]] call fnc_parseInventory];
		if (Z_singleCurrency) then {_coins = _object getVariable [Z_MoneyVariable,0];};

		[_player,_object,0] call server_handleSafeGear;
	} else {
		_inventory = "";
		_object removeAllMPEventHandlers "MPKilled";
		_object removeAllEventHandlers "Killed";
		_object removeAllEventHandlers "HandleDamage";
		_object removeAllEventHandlers "GetIn";
		_object removeAllEventHandlers "GetOut";
		[_object,"killed",false,false,"SERVER",dayz_serverKey] call server_updateObject;
	};
	_message = format ["%1 (%2) cracked %3 (code: %4) @%5 %6 %7nearby: %8 %10%owner PUID: %11 %9", _name, _playerUID, _type, _charID, mapGridPosition _player, _pos, if (_isStorage) then {format ["coins: %1 ",_coins call BIS_fnc_numberText]} else {""}, [_player,600] call fnc_nearBy, _inventory, if (_plotOwner != "None") then {format ["plot owner: %1 ",_plotOwner]} else {""},_ownerPUID];
	diag_log _message;
	["crackLockables",_message] call fnc_Log;
};
