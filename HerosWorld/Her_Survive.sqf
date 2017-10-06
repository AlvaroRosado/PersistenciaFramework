//--->>
if (isNil "Her_Debug") then {Her_Debug=false};
if (Her_Debug) then {diag_log ["--->> Running: Life   SetupHerosSurvive.sqf   --->> INTERN"];};
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> Environment temperature
//--->>
Her_L_AirTemp=22;               // Current air temperature on sea level at 12 o'clock
Her_L_AirTempMin=12;            // Air temperature from which the player starts to freeze
Her_L_AirTempHeight=240;        // Height in meters for 0 level about sea level. (Example: 0 degrees Celsius at altitude 240 meters)
Her_L_WaterTemp=16;             // Current water temperature
Her_L_WaterTempMin=15;          // Water temperature above which the player starts to freeze
Her_L_AirTempBreath=14;         // Foggy breath <= 14 degrees Celsius
Her_L_PlayerBreathInt=0.0001;   // Parameter for foggy breath
Her_L_TempFactor=1.3;           // 
Her_L_BodyTempWarmUpVar=0.025;  //--->> Parameters to increase the body temperature
Her_L_BodyTempCtoF=false;       //--->> Convert body temperature from Celsius to Fahrenheit (HUD)
//--->>
//--->> LLW-Climate
//--->>
//--->>                 0 NUMBER - annual average air temperature
//--->>                 |
//--->>                 |  1 NUMBER - seasonal temperature variation
//--->>                 |  |          difference between average summer and average winter temperatures
//--->>                 |  |
//--->>                 |  |  2 NUMBER - seasonal temperature lag
//--->>                 |  |  |          delay between solstice and min/max temperature levels
//--->>                 |  |  |
//--->>                 |  |  |  3 NUMBER - diurnal temperature variation
//--->>                 |  |  |  |          difference between daily min and max temperatures
//--->>                 |  |  |  |
//--->>                 |  |  |  |  4 NUMBER - diurnal temperature lag
//--->>                 |  |  |  |  |          fraction of time between noon and sunset unti  maximum temperature is reached
//--->>                 |  |  |  |  |          0 for noon, 1 for sunset (default 0.5)
//--->>                 |  |  |  |  |
//--->>                 |  |  |  |  |   5 NUMBER - annual average sea temperature
//--->>                 |  |  |  |  |   |
//--->>                 |  |  |  |  |   |  6 NUMBER - seasonal sea temperature variatio
//--->>                 |  |  |  |  |   |  |          difference between average summer and average winter temperatures
//--->>                 |  |  |  |  |   |  |
//--->>                 |  |  |  |  |   |  | 7 NUMBER - seasonal sea temperature lag
//--->>                 |  |  |  |  |   |  | |          delay between solstice and min/max temperature levels
//--->>                 |  |  |  |  |   |  | |
Her_LLW_Climate_Data = [10,20,30,12,0.5,10,2,60];
//
//	When available, the script will read climatological data from: configFile >> "CfgWorlds" >> worldName >> "climate"
//	Her_LLW_Climate_Data = [];
//
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> Parameter for Hunger, Thirst, Body temperature, ...
//--->>
// Her_L_Hunger=100;
// Her_L_Thirst=100;
// Her_L_BodyTemp=37;
// Her_L_Money=0;
if(isnil "updateStatstoClient") then {
	Her_L_Hunger = 100;
	Her_L_Thirst =  100;
	Her_L_BodyTemp =  36;
	Her_L_Money =  0;
}else{
	
	Her_L_Hunger = profileNamespace getVariable "Her_L_Hunger";
	Her_L_Thirst =  profileNamespace getVariable "Her_L_Thirst";
	Her_L_BodyTemp =  profileNamespace getVariable "Her_L_BodyTemp";
	Her_L_Money =  profileNamespace getVariable "Her_L_Money";
};

// "Her_L_BodyTemp" addPublicVariableEventHandler {
	// _Her_L_BodyTemp = _this select 1;
	// hint str _Her_L_BodyTemp;
// };
// systemChat "Debug: Loaded client packetTest handler.";
// packetTest = [player, 22, Her_L_BodyTemp]; 
// publicVariableServer "packetTest";
//--->>
//--->> -----------------------------------------------------------------------
//--->>
if (isDedicated) exitWith {
	diag_log ["--->> Running: Life   SetupHerosSurvive.sqf   --->> Intern   --->> End - Not player"];
};
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> Main parameter to reduce the BodyTemp
//--->>                0 Air
//--->>                |      1 Water
//--->>                |      |
Her_L_UniformMainList=[0.0009,0.0009,true,false];
//--->>
//--->> Lists of equipment with parameters to reduce the body temperature
//--->>    0.0001   Good thermal insulation
//--->>    0.0009   Poor thermal insulation
//--->>
//--->>  0 Uniform / Vest / Headgear (Class name)
//--->>  |                           1 Parameter Air
//--->>  |                           |      2 Parameter Water
//--->>  |                           |      |
Her_L_UniformList=[
    ["U_B_CombatUniform_mcam_tshirt",0.0006,0.0008],
    ["U_B_CombatUniform_mcam_vest"  ,0.0004,0.0008],
    ["U_B_CombatUniform_mcam"       ,0.0002,0.0008],
    ["U_B_GhillieSuit"              ,0.0001,0.0006],
    ["U_B_Wetsuit"                  ,0.0001,0.0001]
];
Her_L_VestList=[
    ["V_PlateCarrierL_CTRG"         ,0.0004,0.0005],
    ["V_PlateCarrierGL_mtp"         ,0.0004,0.0005],
    ["V_HarnessO_brn"               ,0.0009,0.0005],
    ["V_PlateCarrierGL_rgr"         ,0.0001,0.0005],
    ["V_PlateCarrier1_rgr"          ,0.0001,0.0005],
    ["V_HarnessOSpec_gry"           ,0.0009,0.0005],
    ["V_RebreatherB"                ,0.0003,0.0002]
];
Her_L_HeadgearList=[
    ["H_Watchcap_khk"               ,0.0002,0.0008],
    ["H_Bandanna_camo"              ,0.0004,0.0008],
    ["H_Booniehat_khk_hs"           ,0.0003,0.0008],
    ["H_Beret_02"                   ,0.0003,0.0008],
    ["H_HelmetB_light_snakeskin"    ,0.0005,0.0008],
    ["H_HelmetB_camo"               ,0.0005,0.0008],
    ["H_Hat_camo"                   ,0.0003,0.0008],
    ["H_Bandanna_khk_hs"            ,0.0002,0.0008],
    ["H_Cap_oli_hs"                 ,0.0002,0.0008],
    ["H_Cap_tan_specops_US"         ,0.0002,0.0008],
    ["H_Shemag_olive_hs"            ,0.0001,0.0008],
    ["H_ShemagOpen_khk"             ,0.0001,0.0008],
    ["H_ShemagOpen_tan"             ,0.0001,0.0008],
    ["H_Booniehat_mcamo"            ,0.0003,0.0008]
];
Her_L_GogglesList=[
    ["G_Bandanna_oli"               ,0.0002,0.0009],
    ["G_Bandanna_khk"               ,0.0002,0.0009],
    ["G_Bandanna_aviator"           ,0.0002,0.0009],
    ["G_Balaclava_combat"           ,0.0002,0.0009],
    ["G_Balaclava_oli"              ,0.0002,0.0009]
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//	 (0) Vehicle (Class name)
//	 |								 (1) Safe from ambient temperature and weather (0=no / 1=yes)
//	 |								 | (2) Vehicle use: 0 Diesel / 1=Petrol / 
//	 |								 | | (3) Refill. A canister of fuel (20 liters) increases the fuel value of X
//	 |								 | | |   (4) Maximum distance from the vehicle for refueling with canister and repair.
//	 |								 | | |   | (5) Fuel consumption
//	 |								 | | |   | |        (6) Refill canister with diesel (0=no / 1=yes)
//	 |								 | | |   | |        | (7) Refill canister with petrol (0=no / 1=yes)
//	 |								 | | |   | |        | |
Her_L_VehicleList = [
    ["Her_JeepW_S"                  ,0,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_mover_F"           ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_box_F"             ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_transport_F"       ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_covered_F"         ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_Repair_F"          ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_ammo_F"            ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_medical_F"         ,1,0,0.1,6,0.000015,1,0],
    ["B_Truck_01_fuel_F"            ,1,0,0.1,9,0.000015,1,1],
    ["B_MRAP_01_F"                  ,1,0,0.1,6,0.000015,1,0],
    ["B_MRAP_01_gmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["B_MRAP_01_hmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["O_MRAP_02_F"                  ,1,0,0.1,6,0.000015,1,0],
    ["O_MRAP_02_gmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["O_MRAP_02_hmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["B_G_Offroad_01_armed_F"       ,1,0,0.1,6,0.000015,1,0],
    ["I_Quadbike_01_F"              ,0,1,0.8,6,0.000015,0,1],
    ["O_Quadbike_01_F"              ,0,1,0.8,6,0.000015,0,1],
    ["B_G_Quadbike_01_F"            ,0,1,0.8,6,0.000015,0,1],
    ["B_Quadbike_01_F"              ,0,1,0.8,6,0.000015,0,1],
    ["C_Quadbike_01_F"              ,0,1,0.8,6,0.000015,0,1],
    ["I_MRAP_03_F"                  ,1,0,0.1,6,0.000015,1,0],
    ["I_MRAP_03_gmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["I_MRAP_03_hmg_F"              ,1,0,0.1,6,0.000015,1,0],
    ["C_SUV_01_F"                   ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_device_F"          ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_transport_F"       ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_covered_F"         ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_ammo_F"            ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_repair_F"          ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_medical_F"			,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_03_fuel_F"            ,1,0,0.1,9,0.000015,1,1],
    ["B_G_Van_01_transport_F"       ,1,0,0.1,6,0.000015,1,0],
    ["C_Van_01_transport_F"         ,1,0,0.1,6,0.000015,1,0],
    ["C_Van_01_box_F"               ,1,0,0.1,6,0.000015,1,0],
    ["B_G_Van_01_fuel_F"            ,1,0,0.1,9,0.000015,1,1],
    ["C_Van_01_fuel_F"              ,1,0,0.1,9,0.000015,1,1],
    ["I_Truck_02_transport_F"       ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_02_transport_F"       ,1,0,0.1,6,0.000015,1,0],
    ["I_Truck_02_covered_F"         ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_02_covered_F"         ,1,0,0.1,6,0.000015,1,0],
    ["B_Slingload_01_Fuel_F"        ,1,0,0.1,6,0.000015,1,1],
    ["I_Truck_02_ammo_F"            ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_02_Ammo_F"            ,1,0,0.1,6,0.000015,1,0],
    ["I_Truck_02_box_F"             ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_02_box_F"             ,1,0,0.1,6,0.000015,1,0],
    ["I_Truck_02_medical_F"         ,1,0,0.1,6,0.000015,1,0],
    ["O_Truck_02_medical_F"         ,1,0,0.1,6,0.000015,1,0],
    ["I_Truck_02_fuel_F"            ,1,0,0.1,9,0.000015,1,1],
    ["O_Truck_02_fuel_F"            ,1,0,0.1,9,0.000015,1,1],
    ["B_APC_Tracked_01_CRV_F"       ,1,0,0.1,6,0.000025,1,0],
    ["B_G_Offroad_01_repair_F"      ,1,0,0.1,6,0.000015,1,0],
    ["C_Offroad_01_repair_F"        ,1,0,0.1,6,0.000015,1,0],
    ["O_MBT_02_arty_F"              ,1,0,0.1,6,0.000025,1,0],
    ["I_APC_Wheeled_03_cannon_F"    ,1,0,0.1,6,0.000025,1,0],
    ["B_APC_Wheeled_01_cannon_F"    ,1,0,0.1,6,0.000025,1,0],
    ["O_APC_Tracked_02_cannon_F"    ,1,0,0.1,6,0.000025,1,0],
    ["I_APC_tracked_03_cannon_F"    ,1,0,0.1,6,0.000025,1,0],
    ["B_APC_Tracked_01_AA_F"        ,1,0,0.1,6,0.000025,1,0],
    ["B_APC_Tracked_01_rcws_F"      ,1,0,0.1,6,0.000025,1,0],
    ["B_MBT_01_cannon_F"            ,1,0,0.1,6,0.000025,1,0],
    ["B_MBT_01_TUSK_F"              ,1,0,0.1,6,0.000025,1,0],
    ["B_MBT_01_arty_F"              ,1,0,0.1,6,0.000025,1,0],
    ["B_MBT_01_mlrs_F"              ,1,0,0.1,6,0.000025,1,0],
    ["I_MBT_03_cannon_F"            ,1,0,0.1,6,0.000025,1,0],
    ["O_APC_Wheeled_02_rcws_F"      ,1,0,0.1,6,0.000025,1,0],
    ["O_MBT_02_cannon_F"            ,1,0,0.1,6,0.000025,1,0],
    ["O_APC_Tracked_02_AA_F"        ,1,0,0.1,6,0.000025,1,0],
    ["C_Boat_Civil_01_F"            ,0,1,0.3,6,0.000015,0,1],
    ["B_Boat_Transport_01_F"        ,0,1,0.5,6,0.000015,0,1],
    ["Land_FuelStation_Feed_F"      ,0,1,0.5,6,0.000015,1,1],
    ["Land_Pod_Heli_Transport_04_fuel_F" ,0,0,0.1,6,0.000015,0,0]
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> List of objects with parameters to increase the body temperature
//--->>
Her_L_TempRadiatorList=[];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> List of buildings, in which the player from the ambient temperature is not secure.
//--->>
Her_L_NotSaveHouse=[
    "metal_shed_f","ruins_f","unfinished_building","d_stone_shed_v1_f","u_addon_01_v1_f","pier_f",
    "d_house_small_01_v1_f","d_house_small_02_v1_f","i_addon_04_v1_f","cargo_patrol","cargo_tower_v1_f",
    "d_stone_housesmall_v1_f","dp_mainfactory_f","dp_bigtank_f","Podesta_1_cube","Mil_Barracks_L",
    "Mil_Guardhouse","Sara_domek02","Sara_zluty_statek","Aut_zast","Sara_domek_podhradi_1",
    "Plot_zboreny","Podesta_1_mid","ZalChata","Podesta_1_cube_long","Sara_domek_podhradi_1",
    "Nav_Boathouse_PierR","Nav_Boathouse_PierT","Nav_Boathouse","Sara_domek_zluty_bez",
    "Sara_domek_rosa","Sara_domek_kovarna","KBud","Dum_mesto2l","Sara_domek04","Sara_domek_hospoda",
    "Statek_brana","Podesta_1_cornl","CamoNet_NATO","Mil_Repair_center_EP1","Hlaska","Podesta_s10",
    "Telek1","Brana02","HouseV_1T","HouseV_3I2","Dum_zboreny","Strazni_vez","fort_artillery_nest",
    "Vysilac_FM","Sara_zluty_statek_in","Land_vez","Land_leseni2x","Land_dulni_bs","land_st_vez",
    "land_marsh2","land_lodenice","Land_Nav_Boathouse","Land_CamoNet_EAST","Land_Misc_deerstand",
    "Land_Misc_Cargo1Bo","Land_hut_old01","Land_Misc_Cargo1Ao","Land_hut06","land_bunka","land_b_small1"
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> List of animals that can be slaughtered and count of raw meet
//--->>
//   (0) Animal
//   |                (1) Count of raw meet
//   |                |
Her_L_AnimalCutList=[
    "Sheep_random_F", 3,
    "Goat_random_F",  3,
    "Hen_random_F",   1,
    "Cock_random_f",  1,
    "Turtle_F",       1,
    "Mullet_F",       1,
    "Tuna_F",         1,
    "Mackerel_F",     1,
    "Ornate_random_F",1,
    "Salema_F",       1,
    "Rabbit_F",       1,
    "Cock_white_F",   1
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> For grilling. List of fireplaces
//--->>
Her_L_GrillingFire=[
    "Land_FirePlace_F",
    "FirePlace_burning_F",
    "Land_Campfire_F",
    "Campfire_burning_F",
    "MetalBarrel_burning_F"
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> List of wells to refill a canteen or canister of water
//--->>
//--->> No water to object = 'object setVariable ["Her_L_NoWater",true];'
//--->> Dirty water to object = 'this setVariable ["Her_L_DirtyWater",true];'
//--->>
Her_L_WellList=[
    "Land_Water_source_F","Land_StallWater_F","Land_vill_well",
    "Land_StallWater_F","Land_WaterBarrel_F","Land_WaterTank_F",
    "Land_BarrelWater_grey_F","Land_BarrelWater_F","Land_CanisterPlastic_F","Land_Sink_F",
    "Land_ConcreteWell_01_F","Land_WaterCooler_01_old_F","Land_WaterCooler_01_new_F",
    "Land_WaterTank_02_F","StorageBladder_02_water_sand_F","StorageBladder_02_water_forest_F",
    "Land_WaterTank_01_F","Land_WaterTank_03_F","Land_WaterTank_04_F","Land_WaterTower_01_F",
    "Water_source_F","StallWater_F","vill_well",
    "StallWater_F","WaterBarrel_F","WaterTank_F",
    "BarrelWater_grey_F","BarrelWater_F","CanisterPlastic_F","Sink_F",
    "ConcreteWell_01_F","WaterCooler_01_old_F","WaterCooler_01_new_F",
    "WaterTank_02_F",
    "WaterTank_01_F","WaterTank_03_F","WaterTank_04_F","WaterTower_01_F"
];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> List of objects to refill a canister of disel / petrol
//--->>
//--->> No gas to object = 'object setVariable ["Her_L_NoGas",true];'
//--->>
Her_L_GasList=["land_fuelstation_w"];
//--->>
//--->> -----------------------------------------------------------------------
//--->>
//--->>
//--->> Parameters to reduce the values of life
//--->>
Her_L_HungerVar=0.0058;
Her_L_ThirstVar=0.009;
//--->>
Her_L_SleepToNextCalculation=2;
//--->>
//--->> Parameters for useable light and fire (Remove after ... sec)
//--->>
Her_L_LampSleep=300;
Her_L_FireSleep=300;
//--->>
//--->> Add items that can be used (Output to 'HerosWorld\Her_Survive_UseItems.sqf')
//--->>
Her_L_SpecialUseList = [];
//--->>
//--->> Adding elements, which can be sold
//--->>
//	 (0) Item (Class name)
//	 |						(1) Money
//	 |						|
Her_L_SellList = [
	"herl_eat_apple",		10,
	"herl_eat_bmr",			100,
	"herl_eat_smr",			90,
	"herl_eat_TABA",		80,
	"herl_eat_GB",			80,
	"herl_eat_Rice",		20,
	"herl_eat_CC",			15,
	"herl_eat_grilledM",	100,
	"herl_eat_Fish",		25,
	"herl_dri_milk",		35,
	"herl_dri_RedGul",		25,
	"herl_dri_Spirit",		25,
	"herl_dri_Franta",		25,
	"herl_dri_watera",		25,
	"herl_dri_Canteen",		25,
	"herl_u_bloodbag25",	70,
	"herl_u_bloodbag50",	80,
	"herl_u_bloodbag75",	90,
	"herl_u_bloodbag",		100,
	"herl_u_Canteen",		25,
	"herl_u_cawatere",		5,
	"herl_u_keyv",			80,
	"herl_u_Knife",			100,
	"herl_u_hpack2",		30,
	"herl_u_hpack4",		35,
	"herl_u_hpack6",		40,
	"herl_u_hpack8",		45,
	"herl_u_hpack",			50,
	"herl_u_vitamins2",		20,
	"herl_u_vitamins4",		40,
	"herl_u_vitamins6",		60,
	"herl_u_vitamins8",		80,
	"herl_u_vitamins",		100,
	"herl_u_CFire",			100,
	"herl_u_CLaterne",		100,
	"herl_u_ToolKit",		100,
	"herl_u_bandage",		5,
	"herl_u_defi",			100,
	"herl_u_dsray",			75,
	"herl_u_petrol",		200,
	"herl_u_petrole",		20,
	"herl_u_diesel",		200,
	"herl_u_diesele",		20,
	"herl_u_cawater",		50,
	"herl_u_cawatere",		10,
	"herl_u_Canteen",		50,
	"herl_u_RawM",			60,
	"herl_u_teleport_blu",	300,
	"herl_u_teleport_opf",	300,
	"herl_u_teleport_ind",	300,
	"herl_u_teleport_civ",	300,
	"herl_u_antib_ryan_z",	300,
	"herl_u_antibiotic",	300,
	"herl_u_painkillers",	300,
	"herl_u_ground_sheet",	50,
	"herl_u_satphone",		200,
	"herl_u_rtablet",		250,
	"herl_u_pen",			5,
	"herl_u_pencil",		5,
	"herl_u_Rope",			150,
	"herl_u_SleepingB",		150,
	"herl_u_Tent_A",		250,
	"herl_u_Tent",			250,
	"herl_u_gascooker",		175,
	"herl_u_fm_radio",		50,
	"herl_u_syslaptop",		300,
	"herl_u_laptop",		300,
	"herl_o_tyer",			250,
	"herl_o_excord",		50,
	"herl_o_excord50",		75,
	"herl_o_handyc",		50,
	"herl_o_hammer",		35,
	"herl_o_cloves",		10,
	"herl_0_grinder",		40,
	"herl_o_screwd_a",		15,
	"herl_o_screwd_b",		15,
	"herl_o_screwd_c",		35,
	"herl_o_cbits",			20,
	"herl_o_pliers",		15,
	"herl_o_multim",		45,
	"herl_o_FileA",			50,
	"herl_o_FileB",			300,
	"herl_o_FileC",			150,
	"herl_o_CamoNet",		100,
	"herl_o_MobilePhone_old",150,
	"herl_o_SmartPhone",	250,
	"herl_o_FoldingChair",	25,
	"herl_o_SignLeft",		15,
	"herl_o_SignRight",		15,
	"herl_o_TrafficCone",	15,
	"herl_o_BarrierTapeRW",	15,
	"herl_o_DuctTape",		15,
	"herl_o_Suitcase",		25,
	"herl_o_Skeleton",		75,
	"herl_o_Skull",			50,
	"herl_pager",			150,
	"herl_lighter",			25,
	"herl_matches",			20,
	"herl_copener",			65,
	"herl_ma_Canteen",		20,
	"herl_ma_multim",		20,
	"herl_ma_screwd_c",		20,
	"herl_ma_pager",		100,
	"herl_ma_dspray",		25,
	"herl_ma_fm_radio",		25,
	"herl_mb_pm",			20,
	"herl_mb_waterpur",		20,
	"herl_mb_battery",		30,
	"herl_mb_bandage",		5,
	"Her_Flashlight_01_F",	200,
	"G_her_GasMaskA",		300,
	"herl_o_Money_5",		5,
	"herl_o_Money_10",		10,
	"herl_o_Money_15",		15,
	"herl_o_Money_20",		20,
	"herl_o_Money_25",		25,
	"herl_o_Money_50",		50,
	"herl_o_Money_100",		100,
	"herl_u_FirstAidKit",	200,
	"herl_u_Medikit",		150,
	"herl_o_carbattery_a",	250,
	"herl_o_carbattery_b",	200,
	"16Rnd_9x21_Mag",		100,
	"srifle_DMR_03_multicam_F",3000,
	"20Rnd_762x51_Mag",		150,
	"srifle_GM6_F",			5000,
	"20Rnd_762x51_Mag",		120
];
//--->>
//--->> Adding items that can be purchased
//--->>
Her_L_BuyList = [
	"herl_eat_apple",		10,
	"herl_eat_bmr",			100,
	"herl_eat_smr",			90,
	"herl_eat_TABA",		80,
	"herl_eat_GB",			80,
	"herl_eat_Rice",		20,
	"herl_eat_CC",			15,
	"herl_eat_grilledM",	100,
	"herl_eat_Fish",		25,
	"herl_dri_milk",		35,
	"herl_dri_RedGul",		25,
	"herl_dri_Spirit",		25,
	"herl_dri_Franta",		25,
	"herl_dri_watera",		25,
	"herl_dri_Canteen",		25,
	"herl_u_bloodbag25",	70,
	"herl_u_bloodbag50",	80,
	"herl_u_bloodbag75",	90,
	"herl_u_bloodbag",		100,
	"herl_u_Canteen",		25,
	"herl_u_cawatere",		5,
	"herl_u_keyv",			80,
	"herl_u_Knife",			100,
	"herl_u_hpack2",		30,
	"herl_u_hpack4",		35,
	"herl_u_hpack6",		40,
	"herl_u_hpack8",		45,
	"herl_u_hpack",			50,
	"herl_u_vitamins2",		20,
	"herl_u_vitamins4",		40,
	"herl_u_vitamins6",		60,
	"herl_u_vitamins8",		80,
	"herl_u_vitamins",		100,
	"herl_u_CFire",			100,
	"herl_u_CLaterne",		100,
	"herl_u_ToolKit",		100,
	"herl_u_bandage",		5,
	"herl_u_defi",			100,
	"herl_u_dsray",			75,
	"herl_u_petrol",		200,
	"herl_u_petrole",		20,
	"herl_u_diesel",		200,
	"herl_u_diesele",		20,
	"herl_u_cawater",		50,
	"herl_u_cawatere",		10,
	"herl_u_Canteen",		50,
	"herl_u_RawM",			60,
	"herl_u_teleport_blu",	300,
	"herl_u_teleport_opf",	300,
	"herl_u_teleport_ind",	300,
	"herl_u_teleport_civ",	300,
	"herl_u_antib_ryan_z",	300,
	"herl_u_antibiotic",	300,
	"herl_u_painkillers",	300,
	"herl_u_ground_sheet",	50,
	"herl_u_satphone",		200,
	"herl_u_rtablet",		250,
	"herl_u_pen",			5,
	"herl_u_pencil",		5,
	"herl_u_Rope",			150,
	"herl_u_SleepingB",		150,
	"herl_u_Tent_A",		250,
	"herl_u_Tent",			250,
	"herl_u_gascooker",		175,
	"herl_u_fm_radio",		50,
	"herl_u_syslaptop",		300,
	"herl_u_laptop",		300,
	"herl_o_tyer",			250,
	"herl_o_excord",		50,
	"herl_o_excord50",		75,
	"herl_o_handyc",		50,
	"herl_o_hammer",		35,
	"herl_o_cloves",		10,
	"herl_0_grinder",		40,
	"herl_o_screwd_a",		15,
	"herl_o_screwd_b",		15,
	"herl_o_screwd_c",		35,
	"herl_o_cbits",			20,
	"herl_o_pliers",		15,
	"herl_o_multim",		45,
	"herl_o_FileA",			50,
	"herl_o_FileB",			300,
	"herl_o_FileC",			150,
	"herl_o_CamoNet",		100,
	"herl_o_MobilePhone_old",150,
	"herl_o_SmartPhone",	250,
	"herl_o_FoldingChair",	25,
	"herl_o_SignLeft",		15,
	"herl_o_SignRight",		15,
	"herl_o_TrafficCone",	15,
	"herl_o_BarrierTapeRW",	15,
	"herl_o_DuctTape",		15,
	"herl_o_Suitcase",		25,
	"herl_o_Skeleton",		75,
	"herl_o_Skull",			50,
	"herl_pager",			150,
	"herl_lighter",			25,
	"herl_matches",			20,
	"herl_copener",			65,
	"herl_ma_Canteen",		20,
	"herl_ma_multim",		20,
	"herl_ma_screwd_c",		20,
	"herl_ma_pager",		100,
	"herl_ma_dspray",		25,
	"herl_ma_fm_radio",		25,
	"herl_mb_pm",			20,
	"herl_mb_waterpur",		20,
	"herl_mb_battery",		30,
	"herl_mb_bandage",		5,
	"Her_Flashlight_01_F",	200,
	"herl_u_FirstAidKit",	200,
	"herl_u_Medikit",		150,
	"herl_o_carbattery_a",	250,
	"herl_o_carbattery_b",	200,
	"16Rnd_9x21_Mag",		100,
	"srifle_DMR_03_multicam_F",3000,
	"20Rnd_762x51_Mag",		150,
	"srifle_GM6_F",			5000,
	"20Rnd_762x51_Mag",		120
];
//--->>
//--->> Objects that can be sawn
Her_L_UseSaw=[
	"t_ficus_small_f",
	"t_cyathea_f",
	"t_inocarpus_f",
	"t_leucaena_f",
	"t_ficus_medium_f",
	"b_leucaena_f",
	"b_rhizophora_f",
	"t_cocosnucifera2s_small_f",
	"b_cestrum_f",
	"b_ficusc1s_f",
	"b_ficusc2d_f",
	"t_fraxinusav2s_f",
	"b_neriumo2d_f",
	"t_ficusb2s_f",
	"t_populusn3s_f",
	"t_oleae2s_f",
	"t_oleae1s_f",
	"t_pinuss2s_f",
	"t_pinuss2s_b_f",
	"rowboat_v3_f",
	"pallets_f"
];
