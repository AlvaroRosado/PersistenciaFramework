/*
	Author: Krachenko
	Copyright (C) 2017 Alvaro Rosado
	CLASS OO_VEHICLE
*/

#include "oop.h"
#include "config.sqf"

CLASS("OO_VEHICLE")
	PRIVATE VARIABLE("object","vehicle");
	PRIVATE VARIABLE("string","classname");
	PRIVATE VARIABLE("string","matricula");
	PRIVATE VARIABLE("scalar","id");

	PUBLIC FUNCTION("object","constructor") { 
		private ["_vehicle"];
		_vehicle = _this;
		MEMBER("vehicle", _vehicle);
		MEMBER("classname", typeOf _vehicle);
		MEMBER("id", 0);
	};

	PUBLIC FUNCTION("","getPosicion") {
		getPos MEMBER("vehicle", nil);
	};
	PUBLIC FUNCTION("object","setVehicle") {
		MEMBER("vehicle", _this);
	};
	PUBLIC FUNCTION("","getHitPoint") {
		_hitPoints = [];
		_hpDamage = getAllHitPointsDamage MEMBER("vehicle", _this);

		{
			if (_x != "") then
			{
				_hitPoints pushBack [_x, (_hpDamage select 2) select _forEachIndex];
			};
		} forEach (_hpDamage select 0);
		_hitPoints;
	};
	
	PUBLIC FUNCTION("","getDireccion") {
		 getDir MEMBER("vehicle", nil);
	};
	
	PUBLIC FUNCTION("","getDamage") {
		 getDammage MEMBER("vehicle", nil);
	};
	
	PUBLIC FUNCTION("","getClassName") {
		 MEMBER("classname", nil);
	};
	
	PUBLIC FUNCTION("string","setClassName") {
		 MEMBER("classname", _this);
	};
	
	PUBLIC FUNCTION("","getMatricula") {
		 MEMBER("matricula","123");
	};
	
	PUBLIC FUNCTION("string","setMatricula") {
		 MEMBER("matricula", _this);
	};
	
	PUBLIC FUNCTION("","getId") {
		MEMBER("id",nil);
	};
	
	PUBLIC FUNCTION("scalar","setId") {
		MEMBER("id", _this);
	};
	
	PUBLIC FUNCTION("","getTexturas") {
		private ["_vehicle"];
		_veh = MEMBER("vehicle", nil);
		_textures = getObjectTextures _veh;
		_textures;
	};
	
	PUBLIC FUNCTION("","getCargo") {
		private ["_vehicle", "_vehItems", "_vehMags", "_vehWeapons", "_vehBackpacks", "_vehFuelCargo", "_vehAmmoCargo", "_vehRepairCargo", "_fuel", "_cargo"];
		_vehicle = MEMBER("vehicle", nil);
		
		//killzone_kid the best in the morning
		private _loadout = [];
		{
			_x params ["_items", "_qtys"];
			_loadout set [_forEachIndex, _items apply {[_x, _qtys deleteAt 0]}];
		}
		forEach [getMagazineCargo _vehicle, getWeaponCargo _vehicle, getItemCargo _vehicle, getBackpackCargo _vehicle];
		//killzone_kid the best in the morning

		_vehFuelCargo = getFuelCargo _vehicle;
		_vehAmmoCargo = getAmmoCargo _vehicle;
		_vehRepairCargo = getRepairCargo _vehicle;
		if (!finite(_vehFuelCargo)) then {
			_vehFuelCargo = 0; 
		};
		if (!finite(_vehAmmoCargo)) then {
			_vehAmmoCargo = 0; 
		};
		if (!finite(_vehRepairCargo)) then {
			_vehRepairCargo = 0; 
		};
		_fuel = (fuel _vehicle);
		_cargo = [_vehFuelCargo,_vehAmmoCargo,_vehRepairCargo,_fuel];
		_magsTurret = (magazinesAllTurrets _vehicle) select {_x select 0 != "FakeWeapon" && (_x select 0) select [0,5] != "Pylon"} apply {_x select [0,3]};//Se consigue municion desde todas las torretas del vehiculo

		_cargo pushBack _loadout;
		_cargo pushBack _magsTurret;
		_cargo;
	};
	PUBLIC FUNCTION("array","setCargo") {
		private ["_cargo", "_vehicle", "_vehItems", "_vehMags", "_vehWeapons", "_vehBackpacks", "_vehFuelCargo", "_vehAmmoCargo", "_vehRepairCargo", "_fuel"];
		_cargo = _this;
		_vehicle = MEMBER("vehicle", nil);	
		_vehFuelCargo = _cargo select 0;
		_vehAmmoCargo = _cargo select 1;
		_vehRepairCargo = _cargo select 2;
		_fuel = _cargo select 3;
		_turretMags = _cargo select 5;
		_inventory = _cargo select 4;
		_vehMags = _inventory select 0;
		_vehWeapons = _inventory select 1;
		_vehItems = _inventory select 2;
		_vehBackpacks = _inventory select 3;
		
		clearWeaponCargoGlobal _vehicle;
		clearItemCargoGlobal  _vehicle;
		clearMagazineCargoGlobal  _vehicle;
		clearBackpackCargoGlobal  _vehicle;
		
		if (!(_vehMags isEqualTo [])) then
		{
			{
				_vehicle addMagazineCargoGlobal [_x select 0, _x select 1];
				
			} forEach (_vehMags);
		};

		if (!(_vehWeapons isEqualTo [])) then
		{
			{
				_vehicle addWeaponCargoGlobal [_x select 0, _x select 1];
				
			} forEach (_vehWeapons);
		};
		if (!(_vehItems isEqualTo [])) then
		{
			{
				_vehicle addItemCargoGlobal [_x select 0, _x select 1];

			} forEach (_vehItems);
		};
		if (!(_vehBackpacks isEqualTo [])) then
		{
			{
				_vehicle addBackpackCargoGlobal [_x select 0, _x select 1];
				
			} forEach (_vehBackpacks);
		};
		//quita toda la municion de las torretas del vehiculo
		{ _vehicle removeMagazineTurret (_x select [0,2]) } forEach magazinesAllTurrets _vehicle;
		
		//añade toda la municion guardada a las torretas al vehiculo
		{ _vehicle addMagazineTurret _x } forEach _turretMags;

		if (finite(_vehFuelCargo) || _vehFuelCargo!=0) then {
			_vehicle setFuelCargo _vehFuelCargo;
		};
		if (finite(_vehAmmoCargo) || _vehAmmoCargo!=0) then {
			_vehicle setAmmoCargo _vehAmmoCargo;
		};
		if (finite(_vehRepairCargo) || _vehRepairCargo!=0) then {
			_vehicle setRepairCargo _vehRepairCargo; 
		};
		 _vehicle setFuel _fuel;
	};
	
	PUBLIC FUNCTION("","vehicleInsert") {
		private ["_query", "_ret"];
		_query = format["vehicleInsert:%1:%2:%3:%4:%5:%6:%7:%8:%9", MEMBER("getId",nil),str(MEMBER("getClassName",nil)), MEMBER("getPosicion", nil),MEMBER("getDireccion", nil),MEMBER("getHitPoint",nil),MEMBER("getCargo",nil), MEMBER("getTexturas",nil),0,MEMBER("getDamage",nil)];
		[_query, 1] call fnc_databaseAsyncCall;
	};
	
	PUBLIC FUNCTION("","totalVehicle") {
		private ["_query", "_ret"];
		_query = format["totalVehicle"];
		_ret = [_query, 2] call fnc_databaseAsyncCall;
		_ret;
	};
	PUBLIC FUNCTION("","vehicleDeleteAll") {
		private ["_query", "_ret"];
		_query = format["vehicleDeleteAll"];
		[_query, 1] call fnc_databaseAsyncCall;
	};
	PUBLIC FUNCTION("","vehicleGetbyId") {
		private ["_query", "_ret"];
		_query = format["vehicleGetbyId:%1", MEMBER("getId",nil)];
		_ret = [_query, 2] call fnc_databaseAsyncCall;
		_ret;
	};
	
	PUBLIC FUNCTION("array","aplicarDatosPlayerDB") {

		_data = _this;
		_vehicle = MEMBER("vehicle", nil);
		_classname = "";
		_posicion = "";
		_direccion = 0;
		_hitPoints = [];
		_cargo = [];
		_textures = [];
		_matricula = 0;
		_damage = 0;
		{
			switch (_forEachIndex) do
			{
				/* CLASSNAME */
				case 0:
				{
					_classname = _x;

				};
				/* POSICION */
				case 1:
				{
					if (!(_x isEqualTo [])) then
					{
						_posicion = _x;
					};
				};
	
				/* DIRECCION */
				case 2:
				{
				
					if (_x != 0) then
					{
						_direccion = _x;
					};
					
				};
				/* HITPOINT */
				case 3:
				{
					if (!(_x isEqualTo [])) then
					{
						_hitPoints = _x;
					};
					
				};
				
				/* CARGO */
				case 4:
				{

					if (!(_x isEqualTo [])) then
					{
						_cargo = _x;
					};

				};
				/* TEXTURA */
				case 5:
				{
				
					if (!(_x isEqualTo [])) then
					{
						_textures = _x;
					};

				};
				/* MATRICULA */
				case 6:
				{

					if (_x != 0) then
					{
						_matricula = _x;
					};
				
				};
				
				/* DAMAGE */
				case 7:
				{

					if (_x != 0) then
					{
						_damage = _x;
					};

				};
			
			};
		} forEach _data;
		//CREAR VEHICULO
		_veh = _classname createVehicle _posicion;
		MEMBER("setVehicle",_veh);
		_veh enableSimulation false;
		if (!(_textures isEqualTo [])) then
		{
			_veh setVariable ["BIS_enableRandomization", false, true];

			{
				_veh setObjectTextureGlobal  [_forEachIndex, _x]; 

			} forEach _textures;

		};
		_veh setDir _direccion;
		_veh enableSimulation true;
		if (!(_hitPoints isEqualTo [])) then
		{
			{ 
				_veh setHitPointDamage _x;
			} forEach _hitPoints;
		};
		
		MEMBER("setCargo",_cargo);
		
		//damages--> Lo dejo de momento no es necesario vale con los hitpoints
		//matricula--> Standby de momento no uso el campo -- Futura propiedad de vehiculos?

	};
	
	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("vehicle");	
		DELETE_VARIABLE("classname");
		DELETE_VARIABLE("matricula");
		DELETE_VARIABLE("id");
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