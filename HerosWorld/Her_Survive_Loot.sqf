if (not isServer) exitWith {};
if (isNil "Her_Debug") then {Her_Debug=false};
//--->>
if (Her_Debug) then {diag_log ["--->> Running: Life   Her_Survive_Loot.sqf   --->> EXTERN"];};
//--->>
//--->> -----------------------------------------------------------------------
//--->>
Her_L_LootPresence = 100;               // Presence of Loot in percent
Her_L_LootDistBuildingMin = 20;         // Spawn loot when player more then 20 meters to the building
Her_L_LootDistBuildingMax = 450;        // Spawn loot when player less then 450 meters to the building
Her_L_LootDistBuildingHeight=30;		// Spawn loot when player less then 30 meters to the building in the height
//--->>
Her_L_LootCount = [2,3,4,5];            // Count of loot at the position in the building. Random.
//--->>
//--->> Which Loot may be spawned. (Applies to all buildings that are not defined separately.)
//--->>
Her_L_LootWhat = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
//--->>
//--->> --- The loot to spawn -------------------------------------------------
//--->> - Depending on the mission, the data need to be adjusted
//--->>
//	 0	Backpack
//	 1	Magazine
//	 2	Weapon (primaryWeapon)
//	 3	Weapon (secondaryWeapon)
//	 4	Weapon (handgunWeapon)
//	 5	Items
//	 6	Items
//	 7	Items
//	 8	Items
//	 9	Items
//	10	Items
//	11	Items
//	12	Items
//	13	Items
//	14	Items
//	15	Items
//	16	Items
//	17	Items     A
//	18	Items     B
//	19	Items     C
//	20	Items     D
//
Her_L_LootBackp =    ["B_UAV_01_backpack_F","B_AssaultPack_mcamo","B_AssaultPack_ocamo","B_AssaultPack_dgtl","B_Carryall_oli","B_Carryall_ocamo","B_Carryall_mcamo","B_FieldPack_oli","B_FieldPack_ocamo","B_FieldPack_cbr"];
Her_L_LootMags =     ["20Rnd_762x51_Mag","30Rnd_65x39_caseless_mag","20Rnd_762x51_Mag","150Rnd_762x51_Box_Tracer","20Rnd_762x51_Mag","150Rnd_762x51_Box","20Rnd_762x51_Mag","10Rnd_762x51_Mag","20Rnd_762x51_Mag","7Rnd_408_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","100Rnd_65x39_caseless_mag","20Rnd_762x51_Mag","30Rnd_65x39_caseless_mag","20Rnd_762x51_Mag","30Rnd_65x39_caseless_mag_Tracer","20Rnd_762x51_Mag","6Rnd_45ACP_Cylinder","20Rnd_762x51_Mag","100Rnd_65x39_caseless_mag_Tracer","20Rnd_762x51_Mag","20Rnd_762x51_Mag","16Rnd_9x21_Mag","20Rnd_762x51_Mag"];
Her_L_LootWeaponP =  ["arifle_MX_Black_F","LMG_Zafir_F","srifle_DMR_01_F","srifle_LRR_camo_F","arifle_MXM_F","srifle_EBR_F"];
Her_L_LootWeaponS =  [];
Her_L_LootWeaponH =  ["hgun_Pistol_heavy_02_F","hgun_P07_F","Her_Flashlight_01_F"];
Her_L_LootUniform =  ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_vest","U_B_CombatUniform_mcam_tshirt","U_B_GhillieSuit","U_B_Wetsuit"];
Her_L_LootHeadgear = ["H_Watchcap_khk","H_Bandanna_camo","H_Booniehat_khk_hs","H_her_Booniehat_TIGER","H_her_Booniehat_WDL","H_Beret_02","H_HelmetB_light_snakeskin","H_HelmetB_camo","H_Hat_camo","H_Bandanna_khk_hs","H_Cap_oli_hs","H_Cap_tan_specops_US","H_Shemag_olive_hs","H_ShemagOpen_khk","H_ShemagOpen_tan"];
Her_L_LootVest =     ["V_PlateCarrierL_CTRG","V_PlateCarrierGL_mtp","V_HarnessO_brn","V_PlateCarrierGL_rgr","V_PlateCarrier1_rgr","V_HarnessOSpec_gry","V_RebreatherB"];
Her_L_LootAss =      ["ItemCompass","Binocular","ItemGPS","ItemMap","ItemWatch","Rangefinder"];
Her_L_LootItem =     ["SatchelCharge_Remote_Mag","APERSTripMine_Wire_Mag","ClaymoreDirectionalMine_Remote_Mag","B_UavTerminal","bipod_01_F_mtp","DemoCharge_Remote_Mag","optic_Aco","optic_Hamr","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight_smg","optic_SOS","acc_flashlight","acc_pointer_IR","optic_MRCO","optic_tws","optic_Arco","optic_Holosight","muzzle_snds_acp","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS"];
Her_L_LootFood =     ["herl_dri_milk","herl_dri_watera","herl_dri_Spirit","herl_dri_Franta","herl_dri_RedGul","herl_dri_Canteen","herl_eat_bmr","herl_eat_smr","herl_eat_TABA","herl_eat_GB","herl_eat_Rice","herl_eat_CC"];
Her_L_LootTools =    ["herl_o_FileA","herl_o_FileB","herl_o_FileC","herl_u_laptop","herl_o_card_yell","herl_o_card_red","herl_o_card_green","herl_o_card_blue","herl_o_card_black","herl_u_laptop"];
Her_L_LootUse =      ["herl_u_syslaptop","herl_u_cawatere","herl_u_cawater","herl_u_ToolKit","herl_u_diesele","herl_u_diesel","herl_u_petrole","herl_u_petrol","herl_u_CFire","herl_u_CLaterne","herl_u_Knife"];
Her_L_LootSpecial =  ["muzzle_snds_B","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_H_MG"];
Her_L_LootAidA =     ["herl_u_hpack","herl_u_hpack2","herl_u_hpack4","herl_u_hpack6","herl_u_hpack8","herl_u_bloodbag","herl_u_bloodbag25","herl_u_bloodbag50","herl_u_bloodbag75","herl_u_vitamins","herl_u_vitamins2","herl_u_vitamins4","herl_u_vitamins6","herl_u_vitamins8"];
Her_L_LootAidB =     ["herl_u_hpack","herl_u_hpack2","herl_u_hpack4","herl_u_hpack6","herl_u_hpack8","herl_u_bloodbag","herl_u_bloodbag25","herl_u_bloodbag50","herl_u_bloodbag75","herl_u_vitamins","herl_u_vitamins2","herl_u_vitamins4","herl_u_vitamins6","herl_u_vitamins8"];
Her_L_LootGogg =     ["G_her_GasMaskA","G_Bandanna_khk","G_Bandanna_aviator","G_Combat","G_Balaclava_combat","G_Balaclava_oli","G_B_Diving","G_Aviator","G_Shades_Black"];
Her_L_LootItemA =    ["herl_u_cawater","herl_u_cawatere","herl_u_Canteen","herl_u_hackp","herl_u_Knife","herl_u_keyv","herl_u_syslaptop","herl_ma_Canteen","herl_ma_multim","herl_ma_pager","herl_mb_pm","herl_mb_waterpur","herl_mb_battery","herl_o_tyer","herl_o_multim","herl_o_CamoNet","herl_o_cloves","herl_ma_fm_radio"];
Her_L_LootItemB =    ["herl_o_Money_5","herl_o_Money_10","herl_o_Money_15","herl_o_Money_20","herl_o_Money_25","herl_o_Money_50","herl_o_Money_100"];
Her_L_LootItemC =    [];
Her_L_LootItemD =    [];
//--->>
//--->> All buildings where loot is possible
//--->> - For special islands, these data have to be adjusted.
//--->>
Her_L_HouseClassListMain=[
"Land_A_GeneralStore_01","Land_A_Office01","Land_A_Office01_EP1","Land_A_Pub_01","Land_Afbarabizna",
"Land_Airport_Tower_F","Land_Ammostore2","Land_Army_hut_int","Land_Army_hut2","Land_Army_hut2_int",
"Land_Army_hut3_long","Land_Army_hut3_long_int","Land_Barn_W_01","Land_Barn_W_02","Land_Barrack2",
"Land_Benzina_schnell","Land_Bouda_plech","Land_Bouda2_vnitrek","Land_Budova2","Land_Budova3",
"Land_Budova4_in","Land_cargo_house_slum_F","Land_Cargo_House_V1_F","Land_Cargo_House_V2_F","Land_Cargo_House_V3_F",
"Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F",
"Land_Cargo_Patrol_V3_F","Land_CarService_F","Land_Castle_01_tower_F","Land_Chapel_Small_V1_F","Land_Chapel_V1_F",
"Land_Cihlovej_Dum_mini","Land_d_House_Big_01_V1_F","Land_d_House_Small_01_V1_F","Land_d_House_Small_02_V1_F",
"Land_d_Stone_HouseBig_V1_F","Land_d_Stone_HouseSmall_V1_F","Land_d_Stone_HouseSmall_V2_F","Land_d_Stone_HouseSmall_V3_F",
"Land_Deutshe_mini","Land_Dum_istan3_hromada2","Land_Dum_mesto_in","Land_Dum_mesto2","Land_Dum_olez_istan1",
"Land_Dum_olez_istan2","Land_Dum_olez_istan2_maly","Land_Dum_olezlina","Land_Dum_rasovna","Land_Dum_zboreny",
"Land_Factory_Main_F","Land_Farm_Cowshed_a","Land_Farm_Cowshed_c","Land_Garaz","Land_Garaz_bez_tanku","Land_GH_Gazebo_F",
"Land_GH_House_1_F","Land_GH_House_2_F","Land_GH_MainBuilding_left_F","Land_GH_MainBuilding_middle_F",
"Land_GH_MainBuilding_right_F","Land_Hangar_F","Land_Hlidac_budka","Land_Hlidac_Budka_EP1","Land_Hospoda_mesto",
"Land_House_C_2_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1",
"Land_House_C_5_V3_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1",
"Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_dam_EP1","Land_House_K_8_dam_EP1","Land_House_L_1_EP1",
"Land_House_L_3_EP1","Land_House_y","Land_HouseV_1I4","Land_HouseV2_02_Interier","Land_HouseV2_04_interier",
"Land_Hruzdum","Land_Hut01","Land_Hut02","Land_Hut04","Land_i_Addon_02_V1_F","Land_i_Addon_03_V1_F","Land_i_Barracks_V1_F",
"Land_i_Barracks_V2_F","Land_i_Garage_V1_dam_F","Land_i_Garage_V1_F","Land_i_Garage_V2_F","Land_i_House_Big_01_V1_dam_F",
"Land_i_House_Big_01_V1_F","Land_i_House_Big_01_V2_F","Land_i_House_Big_02_V1_F","Land_i_House_Big_02_V2_F",
"Land_i_House_Big_02_V3_F","Land_i_House_Small_01_V1_F","Land_i_House_Small_01_V2_F","Land_i_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F","Land_i_House_Small_02_V3_F","Land_i_House_Small_03_V1_F","Land_i_Shed_Ind_F",
"Land_i_Shop_01_V1_F","Land_i_Shop_01_V3_F","Land_i_Shop_02_V1_F","Land_i_Shop_02_V2_F","Land_i_Shop_02_V3_F",
"Land_i_Stone_HouseBig_V1_F","Land_i_Stone_HouseBig_V2_F","Land_i_Stone_HouseBig_V3_F","Land_i_Stone_HouseSmall_V1_F",
"Land_i_Stone_HouseSmall_V2_F","Land_i_Stone_HouseSmall_V3_F","Land_i_Stone_Shed_V1_F","Land_i_Stone_Shed_V2_F",
"Land_i_Stone_Shed_V3_F","Land_Ind_Coltan_Main_EP1","Land_Ind_Garage01","Land_Ind_Pec_01","Land_Ind_SiloVelke_01",
"Land_Ind_Vysypka","Land_Ind_Workshop01_01","Land_Ind_Workshop01_02","Land_Ind_Workshop01_04","Land_Kiosk_gyros_F",
"Land_Kiosk_papers_F","Land_Kiosk_redburger_F","Land_Kostel","Land_LHD_1","Land_LHD_2","Land_LHD_3","Land_LHD_4",
"Land_LHD_5","Land_LHD_6","Land_LHD_house_1","Land_LHD_house_2","Land_Mil_Barracks_i","Land_Mil_Barracks_i_EP1",
"Land_Mil_ControlTower","Land_MilOffices_V1_F","Land_Nav_Boathouse","Land_Offices_01_V1_F","Land_Panelak","Land_Panelak2",
"Land_Ryb_domek","Land_Sara_domek_zluty","Land_Sara_domek04","Land_Sara_domek05","Land_Sara_hasic_zbroj","Land_Sara_stodola",
"Land_Sara_stodola2","Land_Sara_zluty_statek_in","Land_Shed_wooden","Land_Slum_House01_F","Land_Slum_House02_F",
"Land_smd_Budova4_in","Land_smd_cihlovej_dum_mini","Land_smd_dum_mesto_in_open","Land_smd_dum_olezlina_open",
"Land_smd_garaz_open","Land_Stodola_old_open","Land_Stodola_open","Land_TentHangar_V1_F","Land_Tovarna2","Land_u_Addon_02_V1_F",
"Land_u_House_Big_01_V1_dam_F","Land_u_House_Big_01_V1_F","Land_u_House_Big_01_V2","Land_u_House_Big_02_V1_dam_F",
"Land_u_House_Big_02_V1_F","Land_u_House_Small_01_V1_dam_F","Land_u_House_Small_01_V1_F","Land_u_House_Small_02_V1_F",
"Land_u_Shed_Ind_F","Land_u_Shop_01_V1_F","Land_u_Shop_02_V1_F","Land_Unfinished_Building_01_F","Land_Unfinished_Building_02_F",
"Land_ZalChata","Land_smd_dum_olez_istan1_open","Land_smd_dum_olez_istan1_open2","Land_smd_dum_olez_istan2_maly_open",
"Land_smd_dum_olez_istan2_open2","Land_smd_dum_olez_istan2_open","Land_smd_dum_istan2","Land_smd_Panelak2","Land_Hangar_2",
"Land_smd_garaz_bez_tanku","Land_smd_garaz_long_open","Land_smd_army_hut3_long_int","Land_smd_dum_istan3_hromada",
"Land_Dum_istan3_pumpa","Land_Dulni_bs","Land_Sara_Domek_sedy","Land_smd_sara_stodola2","Land_smd_garaz_mala_open",
"Land_smd_hut01","Land_smd_sara_zluty_statek_in","Land_smd_army_hut2","Land_smd_hotel","Land_smd_house_y_open",
"Land_smd_army_hut2_int","Land_smd_hospoda_mesto","Land_Ind_Workshop01_L","Land_House_L_8_dam_EP1","Land_House_C_1_dam_EP1",
"Land_House_C_1_v2_dam_EP1","Land_House_C_9_dam_EP1","Land_House_C_2_DAM_EP1","Land_House_L_4_dam_EP1","Land_House_L_7_dam_EP1",
"Land_House_L_6_dam_EP1","Land_House_K_6_dam_EP1","Land_House_K_7_EP1","Land_House_K_3_dam_EP1","Land_House_C_11_dam_EP1",
"Land_House_C_5_V3_dam_EP1","Land_House_C_4_dam_EP1","Land_i_Stone_HouseSmall_V3_dam_F","Land_i_Stone_HouseSmall_V2_dam_F",
"Land_i_Stone_HouseBig_V2_dam_F","Land_u_Shop_02_V1_dam_F","Land_u_Shop_01_V1_dam_F","Land_d_House_Big_02_V1_F",
"Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_L_6_EP1","Land_House_L_4_EP1","Land_House_C_3_EP1","Land_House_C_1_v2_EP1",
"Land_House_C_1_EP1","Land_House_C_9_EP1","Land_A_Hospital","Land_i_House_Big_02_V3_dam_F","Land_i_Shop_01_V3_dam_F",
"Land_R_HouseV2_02","Land_A_Stationhouse_ep1","Land_i_House_Big_01_V3_dam_F","Land_raz_hut01","Land_raz_hut02","Land_raz_hut03",
"Land_raz_hut04","Land_raz_hut05","Land_raz_hut06","Land_raz_hut07","LAND_UNS_HootchE","LAND_uns_om","LAND_UNS_GuardHouse",
"LAND_csj_hut01","LAND_csj_hut02","LAND_CSJ_hut05","LAND_uns_hut08","LAND_CSJ_hut07","LAND_uns_leanto2","Land_Metal_Shed_F"
];
sleep 0.25;
//--->>
//--->> What loot is possible in this building
//--->> (The building must be defined in the 'Her_L_HouseClassListMain' list.)
//--->>
Her_L_HouseClassListLoot=[
"Land_Cargo_HQ_V1_F",[0,1,2,4,5],
"Land_Cargo_HQ_V2_F",[0,1,2,4,5],
"Land_Cargo_House_V2_F",[0,1,2,4,5]
];
//--->>
//--->>
if (Her_Debug) then {diag_log ["--->> Running: Life   Her_Survive_Loot.sqf   --->> EXTERN   --->> End"];};
