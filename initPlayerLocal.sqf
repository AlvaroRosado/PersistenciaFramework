waitUntil { !isNull player };

waitUntil { alive player };

if (player getVariable ["client_initDone", false]) exitWith {};

private _player = player;

_player addEventHandler
[
	"Killed",
	{
		private _player = _this select 0;
		pvJugadorMuerto = _player;
		publicVariableServer "pvJugadorMuerto";
		_player setVariable ["client_initDone", nil, false];
		_player removeEventHandler ["Killed", _thisEventHandler];
	}
];

pvNuevoJugador = _player;
publicVariableServer "pvNuevoJugador";
"updateStatstoClient" addPublicVariableEventHandler {
	_array = _this select 1;
	profileNamespace setVariable ["Her_L_Hunger",_array select 0];
	profileNamespace setVariable ["Her_L_Thirst",_array select 1];
	profileNamespace setVariable ["Her_L_BodyTemp",_array select 2];
	profileNamespace setVariable ["Her_L_Money", _array select 3];
};
_player setVariable ["client_initDone", true, false];
