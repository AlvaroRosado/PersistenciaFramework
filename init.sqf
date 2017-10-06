/*
	Author: Krachenko
	Copyright (C) 2017 Alvaro Rosado
	init.sqf
*/

HAMBRE_DEFAULT = 100;
SED_DEFAULT = 100;
TEMPERATURA_CUERPO_DEFAULT = 36; 
DINERO_DEFAULT = 0;

call compile preprocessFileLineNumbers "funciones.sqf";
call compilefinal preprocessFileLineNumbers "Clases\oo_database.sqf";
call compilefinal preprocessFileLineNumbers "Clases\oo_player.sqf";
call compilefinal preprocessFileLineNumbers "Clases\oo_vehicle.sqf";

if (isServer || isDedicated) then
{
	_conexion = ["new"] call OO_DATABASE;
	"EventHandlers" call _conexion;
	[] spawn fnc_LoadDataWorld;
};
_handler = [2,0,1,2,0,4,0,0,0,1,0,1,1,0] execVM "\her_a3w_survive\scripts\init_her_survive.sqf";
waitUntil {scriptDone _handler};

if(hasInterface) then {
	waitUntil {alive player};
	while {alive player} do {
		sleep 0.2;
		updateStats = [player,Her_L_Hunger,Her_L_Thirst,Her_L_BodyTemp,Her_L_Money];
		publicVariableServer "updateStats";
		sleep 5;
	};
};