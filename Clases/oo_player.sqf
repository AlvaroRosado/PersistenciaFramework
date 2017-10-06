/*
	Author: Krachenko
	Copyright (C) 2017 Alvaro Rosado
	CLASS OO_PLAYER 
*/

#include "oop.h"
#include "config.sqf"

CLASS("OO_PLAYER")
	PRIVATE VARIABLE("object","unit");
	PRIVATE VARIABLE("string","uid");
	PRIVATE VARIABLE("string","nombre");

	PUBLIC FUNCTION("object","constructor") { 
		private ["_player","_uid","_nombre"];
		_player = _this;
		_uid = getPlayerUID _player;
		_nombre = name _player;
		MEMBER("unit", _player);
		MEMBER("uid", _uid);
		MEMBER("nombre", _nombre);
	};
	
	PUBLIC FUNCTION("","getUid") {
		MEMBER("uid", nil);
	};

	PUBLIC FUNCTION("","getName") {
		MEMBER("nombre", nil);
	};

	PUBLIC FUNCTION("","getPosicion") {
		getPos MEMBER("unit", nil);
	};

	PUBLIC FUNCTION("","getLoadOut") {
		getUnitLoadout MEMBER("unit", nil);
	};
	
	PUBLIC FUNCTION("","getHitPoint") {
		// getAllHitPointsDamage MEMBER("unit", nil);		
		// _hpDamage = getAllHitPointsDamage MEMBER("unit", nil);
		 // "head"
		 // "body"
		 // "arm_r"
		 // "arm_l"
		 // "leg_r"
		 // "leg_l"
		// _hpDamage;
		_damageLife = (MEMBER("unit", nil) getVariable["ACE_medical_bodyPartStatus", [0,0,0,0,0,0]]);
		MEMBER("ToLog", _damageLife joinString "");
		_damageLife;
	};


	PUBLIC FUNCTION("","getDireccion") {
		 getDir MEMBER("unit", nil);
	};
	
	PUBLIC FUNCTION("","getVivo") {
		alive MEMBER("unit", nil);
	};
	
	PUBLIC FUNCTION("","getInconsciente") {
		MEMBER("unit", nil) getVariable ["BAS_isIncapacitated",false];
	};
	
	PUBLIC FUNCTION("string","setUid") {
		MEMBER("uid", _this);
	};
		
	PUBLIC FUNCTION("","getTemperaturaCuerpo") {
		MEMBER("unit", nil) getVariable ["Her_L_BodyTemp",36];
	};
	
	PUBLIC FUNCTION("scalar","setTemperaturaCuerpo") {
		MEMBER("unit", nil) setVariable ["Her_L_BodyTemp", _this, true];
	};
	
	PUBLIC FUNCTION("","getDinero") {
		MEMBER("unit", nil) getVariable ["Her_L_Money",0];
	};
	
	PUBLIC FUNCTION("scalar","setDinero") {
		MEMBER("unit", nil) setVariable ["Her_L_Money", _this, true];
	};
	
	PUBLIC FUNCTION("","getHambre") {
		MEMBER("unit", nil) getVariable ["Her_L_Hunger",100];
	};
	
	PUBLIC FUNCTION("scalar","setHambre") {
		MEMBER("unit", nil) setVariable ["Her_L_Hunger", _this, true];
	};
	
	PUBLIC FUNCTION("","getSed") {
		MEMBER("unit", nil) getVariable ["Her_L_Thirst",100];
	};
	
	PUBLIC FUNCTION("scalar","setSed") {
		MEMBER("unit", nil) setVariable ["Her_L_Thirst", _this, true];
	};
	
	PUBLIC FUNCTION("","existePlayerDB") {
		private ["_query", "_ret"];
		 _query = format["playerExists:%1:%2", MEMBER("getUid", nil), MEMBER("getName", nil)];
		_ret = ([_query, 2] call fnc_databaseAsyncCall) select 0;
		_ret;
	};
	
	PUBLIC FUNCTION("","insertaPlayerDB") {
		private ["_query", "_ret"];
		_query = format["playerInsert:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10", MEMBER("getUid",nil), MEMBER("getName",nil),MEMBER("getDireccion",nil),MEMBER("getLoadOut",nil),MEMBER("getHitPoint",nil), MEMBER("getPosicion",nil), MEMBER("getInconsciente",nil),MEMBER("getHambre",nil),MEMBER("getSed",nil),MEMBER("getDinero",nil)];
		[_query, 1] call fnc_databaseAsyncCall;
	};
	
	PUBLIC FUNCTION("","updatePlayerInfoDB") {
		private ["_query", "_ret"];
		_query = format["playerUpdateInfo:%1", MEMBER("getUid",nil)];
		[_query, 1] call fnc_databaseAsyncCall;
	};
	
	PUBLIC FUNCTION("","cargaDatosPlayerDB") {
		private ["_query", "_ret"];
		_query = format["playerGetData:%1:%2", MEMBER("getUid",nil), MEMBER("getName",nil)];
		_ret = [_query, 2] call fnc_databaseAsyncCall;
		_ret;
	};
	
	PUBLIC FUNCTION("","updatePlayerDataDB") {
		private ["_player", "_query"];
		_player = MEMBER("unit", nil);
		if (MEMBER("getVivo", nil)) then{
			
			_query = format["playerUpdateData:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10", MEMBER("getDireccion",nil),MEMBER("getLoadOut",nil),MEMBER("getHitPoint",nil),MEMBER("getPosicion",nil),MEMBER("getInconsciente",nil),MEMBER("getHambre",nil),MEMBER("getSed",nil),MEMBER("getDinero",nil),MEMBER("getUid",nil),MEMBER("getName",nil)];
			[_query, 1] call fnc_databaseAsyncCall;
			deleteVehicle _player;
		}else
		{
			MEMBER("resetPlayerDataDB", nil);
		};
	};
		
	PUBLIC FUNCTION("","resetPlayerDataDB") {
		private ["_player", "_query"];
		_player = MEMBER("unit", nil);
		_query = format["playerUpdateData:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10", 0,[],[],[],false,100,100,0,MEMBER("getUid",nil),MEMBER("getName",nil)];
		[_query, 1] call fnc_databaseAsyncCall;
	};
	
	PUBLIC FUNCTION("array","aplicarDatosPlayerDB") {
		private ["_player", "_data", "_direccion", "_hambre", "_sed", "_temperaturaCuerpo", "_dinero", "_nombresHitPoints", "_partesHitPoints", "_cifrasDamage", "_indice", "_partehit", "_damage", "_owner"];
		_player = MEMBER("unit", nil);
		_data = _this;
		_direccion = 0;
		_hambre = 0;
		_sed = 0;
		_temperaturaCuerpo = 39;//De momento no es un valor que se guarde en la DB y se le asigna directamente. Se ha dejado todo preparado para ello o para cambiarlo por otro valor futuro
		_dinero = 0;
		waitUntil { !isNil "bis_fnc_init" && {bis_fnc_init} };
		{
			switch (_forEachIndex) do
			{
				/* DIRECCION */
				case 0:
				{
					if (_x != 0) then
					{
						_direccion = _x;
					};
				};
				/* LOADOUT */
				case 1:
				{
					if (!(_x isEqualTo [])) then
					{
						_player setUnitLoadout [_x, false];
					}

				};
	
				/* HITPOINT */
				case 2:
				{
					_hitSelections = ["head", "body", "arm_r", "arm_l", "leg_r", "leg_l"];
					{
						[_player, _x, _hitSelections select _forEachIndex, "bullet"] remoteExec ["ace_medical_fnc_addDamageToUnit", _player, false];						
					} forEach _x;	
				};
				/* POSICION */
				case 3:
				{
					if (!(_x isEqualTo [])) then
					{
						waitUntil { sleep 0.1; preloadCamera _x };
						// MEMBER("ToLog", _x joinString "");
						_player setDir _direccion;
						_player setPos _x;
					};
					
				};
				
				/* INCONSCIENTE */
				case 4:
				{

					if (_x && (!isNil {revive_fnc_playerIncapacitated})) then
					{
						_player setVariable ["isIncapacitated", true, true];
						_player spawn revive_fnc_playerIncapacitated;
					};

				};
				/* HAMBRE */
				case 5:
				{
				
					MEMBER("setHambre", _x);
					_hambre = _x;
				};
				/* SED */
				case 6:
				{

					MEMBER("setSed", _x);
					_sed = _x;

				};
				
				/* DINERO */
				case 7:
				{

					MEMBER("setDinero", _x);
					_dinero = _x;

				};
			
			
			};
		} forEach _data;

		updateStatstoClient = [_hambre,_sed,_temperaturaCuerpo,_dinero];
		_owner = owner _player;
		(owner _player) publicVariableClient "updateStatstoClient";
	};
	
	PUBLIC FUNCTION("scalar","floatToString") {
		private "_arr";
		_arr = toArray str abs (_this % 1);
		_arr set [0, 32];
		toString (toArray str (
			abs (_this - _this % 1) * _this / abs _this
		) + _arr - [32])
	};

	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("unit");
		DELETE_VARIABLE("uid");
		DELETE_VARIABLE("nombre");

	};

	PUBLIC FUNCTION("string","toLog") {
		switch (MODO_DEBUG) do
		{
			case "RPT":
			{
				diag_log format ["%1", _this];
			};
			case "DEBUG_CONSOLE":
			{
				"debug_console" callExtension _this;
			};
			case "NO":
			{
			
			};
		};
	};
ENDCLASS;