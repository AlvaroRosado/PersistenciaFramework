fnc_databaseAsyncCall={
	/*
		File: fn_asyncCall.sqf
		Author: Bryan "Tonic" Boardwine

		Description:
		Commits an asynchronous call to ExtDB

		Parameters:
			0: STRING (Query to be ran).
			1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
			3: BOOL (True to return a single array, false to return multiple entries mainly for garage).
	*/

	private["_queryStmt","_mode","_multiarr","_queryResult","_key","_return","_loop"];
	_queryStmt = [_this,0,"",[""]] call BIS_fnc_param;
	_mode = [_this,1,1,[0]] call BIS_fnc_param;
	_multiarr = [_this,2,false,[false]] call BIS_fnc_param;

	_key = "extDB3" callExtension format["%1:%2:%3",_mode,call persistencia_protocolID,_queryStmt];

	if (_mode isEqualTo 1) exitWith {true};

	_key = call compile format["%1",_key];
	_key = (_key select 1);
	_queryResult = "extDB3" callExtension format["4:%1", _key];

	//Make sure the data is received
	if (_queryResult isEqualTo "[3]") then {
		for "_i" from 0 to 1 step 0 do {
			if (!(_queryResult isEqualTo "[3]")) exitWith {};
			_queryResult = "extDB3" callExtension format["4:%1", _key];
		};
	};

	if (_queryResult isEqualTo "[5]") then {
		_loop = true;
		for "_i" from 0 to 1 step 0 do { // extDB2 returned that result is Multi-Part Message
			_queryResult = "";
			for "_i" from 0 to 1 step 0 do {
				_pipe = "extDB3" callExtension format["5:%1", _key];
				if (_pipe isEqualTo "") exitWith {_loop = false};
				_queryResult = _queryResult + _pipe;
			};
		if (!_loop) exitWith {};
		};
	};

	_queryResult = call compile _queryResult;
	if ((_queryResult select 0) isEqualTo 0) exitWith {diag_log format ["extDB2: Protocol Error: %1", _queryResult]; []};
	_return = (_queryResult select 1);
	if (!_multiarr && count _return > 0) then {
		_return = (_return select 0);
	};

	_return;
};

fnc_loadPlayerData =
{
	private ["_player", "_existe", "_return"];
	_player = ["new", _this] call OO_PLAYER;
	_existe = "existePlayerDB" call _player;
	
	if (!_existe) then	
	{
		updateStatstoClient = [HAMBRE_DEFAULT,SED_DEFAULT,TEMPERATURA_CUERPO_DEFAULT,DINERO_DEFAULT];//HAMBRE,SED,TEMPERATURA,DINERO --> VALORES POR DEFECTO
		(owner _this) publicVariableClient "updateStatstoClient";
		"insertaPlayerDB" call _player;
	}
	else
	{
		"updatePlayerInfoDB" call _player;
		_return = "cargaDatosPlayerDB" call _player;
		["aplicarDatosPlayerDB", _return] call _player;
	};
};

fnc_updatePlayerStats =
{	
	private ["_unit", "_hambre", "_sed", "_temperaturaCuerpo", "_dinero", "_player"];
	_unit = _this select 0;
	_hambre = _this select 1;
	_sed = _this select 2;
	_temperaturaCuerpo = _this select 3;
	_dinero = _this select 4;
	_unit setVariable ["HerPlLife",_this,true];
	 _player = ["new", _unit] call OO_PLAYER;
	 ["setHambre", _hambre] call _player;
	 ["setSed", _sed] call _player;
	 ["setTemperaturaCuerpo", _temperaturaCuerpo] call _player;
	 ["setDinero", _dinero] call _player;
};

fnc_PlayerUpdateData =
{
	private ["_unit", "_player"];
	_unit = _this select 0;
	_uid  = _this select 2; 
	_player = ["new", _unit] call OO_PLAYER;
	["setUid", _uid] call _player;	
	"updatePlayerDataDB" call _player;
	[] spawn fnc_SaveDataWorld;

};
fnc_SaveDataWorld = {
	_vehiculoCount = 0;
	_oovehicle = ["new", objNull] call OO_VEHICLE;
	"vehicleDeleteAll" call _oovehicle;		
	{
		_vehiculo = _x;
		_volando = (!isTouchingGround _vehiculo && (getPos _vehiculo) select 2 > 1);
		
		if (alive _vehiculo && {_vehiculo isKindOf "AllVehicles" && !(_vehiculo isKindOf "Man" || _vehiculo isKindOf "StaticWeapon") && ((isTouchingGround _vehiculo || (getPos _vehiculo) select 2 <= 1))}) then
		{
			if (!_volando) then
			{
				private ["_oovehicle"];
				_vehiculoCount = _vehiculoCount + 1;
				_oovehicle = ["new", _vehiculo] call OO_VEHICLE;
				["setId", _vehiculoCount] call _oovehicle;	
				"vehicleInsert" call _oovehicle;		

			};
		};
	} forEach allMissionObjects "AllVehicles";
};

fnc_LoadDataWorld = {
	_oovehicle = ["new", objNull] call OO_VEHICLE;
	_returnTotal = "totalVehicle" call _oovehicle;
	_total = _returnTotal select 0;
	if(_total != 0) then {
		{
			_vehiculo = _x;
			_volando = (!isTouchingGround _vehiculo && (getPos _vehiculo) select 2 > 1);
			if (alive _vehiculo && {_vehiculo isKindOf "AllVehicles" && !(_vehiculo isKindOf "Man" || _vehiculo isKindOf "StaticWeapon") && ((isTouchingGround _vehiculo || (getPos _vehiculo) select 2 <= 1))}) then
			{
				if (!_volando) then
				{
					deleteVehicle _vehiculo;
				};

			};
		} forEach allMissionObjects "AllVehicles";
		
		for "_i" from 1 to _total do {
			["setId", _i] call _oovehicle;	
			_return = "vehicleGetbyId" call _oovehicle;	
			["aplicarDatosPlayerDB", _return] call _oovehicle;
		};
	};
};

fnc_resetPlayerData =
{
	private ["_player"];
	_player = ["new", _this] call OO_PLAYER;
	"resetPlayerDataDB" call _player;
};

