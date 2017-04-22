#include <amxmodx>
#include <cromchat>
#include <cstrike>
#include <customshop>
#include <fun>

// Remove or comment this line if you don't want to remove the previous weapon.
#define STRIP_WEAPONS

#if defined STRIP_WEAPONS
	#include <stripweapons>
#else
enum
{
	Grenades = 0,
	Primary,
	Secondary
}
#endif

#define PLUGIN_VERSION "4.x"

enum _:Weapons
{
	eName[32],
	eItemName[32],
	eCSWName,
	ePrice,
	eAmmo,
	eType
}

new g_eWeapons[][Weapons] =
{
	{ "P228",			"weapon_p228",			CSW_P228,			600,	52, 	Secondary 	},
	{ "Deagle", 		"weapon_deagle", 		CSW_DEAGLE, 		650, 	35, 	Secondary 	},
	{ "Dual Elites", 	"weapon_elite", 		CSW_ELITE, 			800, 	120, 	Secondary 	},
	{ "Five-Seven", 	"weapon_fiveseven", 	CSW_FIVESEVEN, 		750, 	100, 	Secondary 	},
	{ "Glock18", 		"weapon_glock18", 		CSW_GLOCK18, 		400, 	120, 	Secondary 	},
	{ "USP", 			"weapon_usp", 			CSW_USP, 			500, 	100, 	Secondary 	},
	{ "AK47", 			"weapon_ak47", 			CSW_AK47,			2500,	90, 	Primary		},
	{ "AUG", 			"weapon_aug", 			CSW_AUG, 			3500, 	90,  	Primary		},
	{ "AWP", 			"weapon_awp", 			CSW_AWP, 			4750, 	30,  	Primary		},
	{ "Famas", 			"weapon_famas", 		CSW_FAMAS, 			2250, 	90,  	Primary		},
	{ "G3SG1", 			"weapon_g3sg1", 		CSW_G3SG1, 			5000,	90,  	Primary		},
	{ "Galil", 			"weapon_galil", 		CSW_GALIL, 			2000, 	90,		Primary		},
	{ "M249", 			"weapon_m249", 			CSW_M249, 			5750, 	200,	Primary 	},
	{ "M3", 			"weapon_m3", 			CSW_M3, 			1700, 	32, 	Primary		},
	{ "M4A1",			"weapon_m4a1", 			CSW_M4A1, 			3100, 	90, 	Primary 	},
	{ "MAC10", 			"weapon_mac10", 		CSW_MAC10, 			1400, 	100, 	Primary 	},
	{ "MP5 Navy", 		"weapon_mp5navy", 		CSW_MP5NAVY, 		1500, 	120, 	Primary 	},
	{ "P90", 			"weapon_p90", 			CSW_P90,			2350,	100, 	Primary 	},
	{ "SG550", 			"weapon_sg550", 		CSW_SG550, 			4200, 	90, 	Primary 	},
	{ "SG552", 			"weapon_sg552", 		CSW_SG552, 			3500, 	90, 	Primary		},
	{ "Scout", 			"weapon_scout", 		CSW_SCOUT, 			2750,	90, 	Primary 	},
	{ "TMP", 			"weapon_tmp", 			CSW_TMP, 			1250, 	120, 	Primary 	},
	{ "UMP45", 			"weapon_ump45", 		CSW_UMP45, 			1700, 	100, 	Primary 	},
	{ "XM1014", 		"weapon_xm1014", 		CSW_XM1014, 		3000, 	32, 	Primary 	},
	{ "Flashbang", 		"weapon_flashbang", 	CSW_FLASHBANG, 		200,	2, 		Grenades 	},
	{ "HE Grenade", 	"weapon_hegrenade", 	CSW_HEGRENADE, 		300, 	1, 		Grenades 	},
	{ "Smoke Grenade",	"weapon_smokegrenade", 	CSW_SMOKEGRENADE, 	300, 	1, 		Grenades 	}
}

additem ITEM_DEFAULT_WEAPON[32]

public plugin_init()
{
	register_plugin("CSHOP: Default Weapons", PLUGIN_VERSION, "OciXCrom")
	
	new szPrefix[32]
	cshop_get_prefix(szPrefix, charsmax(szPrefix))
	CC_SetPrefix(szPrefix)
}

public plugin_precache()
{
	for(new i; i < sizeof(g_eWeapons); i++)
		ITEM_DEFAULT_WEAPON[i] = cshop_register_item(g_eWeapons[i][eItemName], g_eWeapons[i][eName], g_eWeapons[i][ePrice])
}

public cshop_item_selected(id, iItem)
{
	for(new i; i < sizeof(g_eWeapons); i++)
	{
		if(iItem == ITEM_DEFAULT_WEAPON[i])
		{
			if(user_has_weapon(id, g_eWeapons[i][eCSWName]))
			{
				CC_SendMessage(id, "You already have this weapon!")
				cshop_error_sound(id)
				return DONT_BUY
			}
			
			#if defined STRIP_WEAPONS
			if(g_eWeapons[i][eType] != Grenades)
				StripWeapons(id, g_eWeapons[i][eType])
			#endif
			
			give_item(id, g_eWeapons[i][eItemName])
			cs_set_user_bpammo(id, g_eWeapons[i][eCSWName], g_eWeapons[i][eAmmo])
			engclient_cmd(id, g_eWeapons[i][eItemName])
			break
		}
	}
	
	return BUY_ITEM
}