	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2016 Nicolas BOITEUX

	CLASS OO_INVENTORY simple inventory class
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
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