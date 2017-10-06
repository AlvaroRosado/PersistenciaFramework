//--->>
//--->> External script for processing the clicked items
//--->>
//--->> This script has to be adapted by the Mission Maker
//--->>
if (not local player) exitWith {};
private ["_Item"];
_Item = _this select 0;
//hint format ["Using item:\n%1",_Item];
//--->>
//--->>
switch (_Item) do {
	case "herl_u_laptop": {
		/* Open and close the laptop */ 
		nul = [_Item] execVM "use\UseLaptop.sqf";
	};
	case "herl_u_book": {
		/* Open and close the book */ 
		nul = [_Item] execVM "use\UseBook.sqf";
	};
	case "herl_o_card_black":		{nul=[_Item] execVM "use\UseCheckCard.sqf";};
	case "herl_o_card_blue":		{nul=[_Item] execVM "use\UseCheckCard.sqf";};
	case "herl_o_card_green":		{nul=[_Item] execVM "use\UseCheckCard.sqf";};
	case "herl_o_card_red":			{nul=[_Item] execVM "use\UseCheckCard.sqf";};
	case "herl_o_card_yell":		{nul=[_Item] execVM "use\UseCheckCard.sqf";};
	case "herl_o_saw":				{nul=[_Item,true] execVM "use\SawingWood.sqf";};
	case "herl_u_tripodforgrill":	{nul=[_Item] execVM "use\UseTripodForGrill.sqf";};
	default {
		/* Info on screen. Remove when mission is completed. */ 
		hint format ["Using-Item:\n\nUndefined Item\n\n%1",_Item]
	};
};
