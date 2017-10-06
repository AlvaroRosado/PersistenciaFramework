/*
	Author: Krachenko
	Copyright (C) 2017 Alvaro Rosado
	CLASS OO_DATABASE 
*/
	#include "oop.h"
	#include "config.sqf"

	CLASS("OO_DATABASE")
		PRIVATE VARIABLE("string","conexion");

		PUBLIC FUNCTION("","constructor") { 
			MEMBER("ConectarDB", nil);
		};

		PUBLIC FUNCTION("","ConectarDB") {
			private ["_ret"];
			if (isNil {uiNamespace getVariable "persistencia_protocolID"}) then
			{
				_ret = "extDB3" callExtension "9:VERSION";
				if(_ret == "") exitWith { diag_log "extDB3: Initialization failed" };
				diag_log format ["extDB3 - Version %1", _ret];

				_ret = call compile ("extDB3" callExtension format["9:ADD_DATABASE:%1", DATABASE_NAME]);
				if (_ret select 0 == 0) exitWith { diag_log format ["extDB3 - Database error %1", _ret] };
				diag_log "extDB3 - Database connected";

				persistencia_protocolID = compileFinal str round(random(999999));
				
				_ret = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM:%2:%3", DATABASE_NAME, call persistencia_protocolID,SQL_CUSTOM_FILE]);
				if (_ret select 0 == 0) exitWith { diag_log format ["extDB3 - Database error %1", _ret] };
				diag_log "extDB3 - Custom protocol added";

				"extDB3" callExtension "9:LOCK";
				diag_log "extDB3 - Database locked";
				
				uiNamespace setVariable ["persistencia_protocolID",persistencia_protocolID];
			} 
			else 
			{
				persistencia_protocolID = compileFinal str (uiNamespace getVariable "persistencia_protocolID");
				diag_log "extDB3 - Database already connected";
			};

		};
		
		PUBLIC FUNCTION("","EventHandlers") {
			addMissionEventHandler ["HandleDisconnect", fnc_PlayerUpdateData];
			"pvNuevoJugador" addPublicVariableEventHandler { (_this select 1) spawn fnc_loadPlayerData; };
			"pvJugadorMuerto" addPublicVariableEventHandler { (_this select 1) spawn fnc_resetPlayerData; };	
			"updateStats" addPublicVariableEventHandler { (_this select 1) spawn fnc_updatePlayerStats; };	
			
		};

		PUBLIC FUNCTION("","deconstructor") {
			DELETE_VARIABLE("conexion");
		};
	ENDCLASS;