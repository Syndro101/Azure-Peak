/*==============================\
||							   ||
||  ARMOR PENETRATION DEFINES  ||
||							   ||
\==============================*/

// Penetration tier system
// Weapon penfactor (on intents) vs armor blocking tier (on clothing).
// If penfactor > armor tier: 100% of damage penetrates armor.
// If penfactor == armor tier: 20% of damage penetrates armor.
// If penfactor < armor tier: fully blocked (0 through).
// Blunt uses DR Absorb — damage multiplied by 1 / (1 + 0.2 * DR tier), all absorbed by armor (none to HP).
// Fire/Acid use DR Pierce — same DR formula, but reduced damage still hits HP.

// Penetration tiers (0-4). Weapon attacks.
#define PEN_NONE			0	// No penetration. Training weapons, base cuts/chops.
#define PEN_LIGHT			1	// Falx cut, axe chop. Penetrates trash armor (NPC cloth/bad leather).
#define PEN_MEDIUM			2	// Sword thrusts, longsword chop. Penetrates player light armor (gambeson, hardened leather).
#define PEN_HEAVY			3	// Spear, estoc. Penetrates mail/brigandine/plate at same-tier 20%.
#define PEN_BLACKSTEEL		4	// Halfsword, dagger pick. Penetrates plate fully, blacksteel at 20%.


// Damage Blocking tiers (0-4). Armor clothing.
#define DBLOCK_NONE			0	// No blocking. Unarmored skin.
#define DBLOCK_LIGHT		1	// Cloth, bad leather, NPC trash armor.
#define DBLOCK_MEDIUM		2	// Gambeson, padded, hardened leather, studded — player light armor.
#define DBLOCK_HEAVY		3	// Brigandine, mail, cuirass, plate.
#define DBLOCK_BLACKSTEEL	4	// Blacksteel, antagonist.


// Damage reduction tiers (0-5). Used by blunt (absorb), fire, acid (pierce).
// Note that blunt by default have 1.6x Integrity Multiplier.
// Damage multiplier = 1 / (1 + 0.2 * tier)
// Blunt: all damage absorbed by armor. Fire/Acid: reduced damage still hits HP.
#define DR_NONE				0	// Nothing. 100% damage. EDPS: 160%
#define DR_LIGHT			1	// Plate / Metal. 20% EHP increase. EDPS: 133%
#define DR_MEDIUM			2	// Mail. 40% EHP increase. EDPS: 114%
#define DR_HEAVY			3	// Bad Light Armor. 60% EHP increase. EDPS: 100%
#define DR_SUPER			4	// Medium Light Armor. 80% EHP increase. EDPS: 89%
#define DR_ULTRA			5	// Best quality light armor. 100% EHP increase. EDPS: 80%


// Armor damage type categories
// DR Absorb: damage reduced by tier, ALL damage goes to armor integrity (none to HP). Blunt.
// DR Pierce: damage reduced by tier, reduced damage STILL hits HP. Armor also takes integrity damage. Fire, acid.
// DBLOCK: tier pass/fail penetration system. Slash, stab, piercing.
#define ARMOR_DR_ABSORB_TYPES list("blunt")
#define ARMOR_DR_PIERCE_TYPES list("fire", "acid")
#define ARMOR_DR_TYPES list("blunt", "fire", "acid")
#define ARMOR_DBLOCK_TYPES list("slash", "stab", "piercing")


// Penetration passthrough fractions
#define PEN_PASSTHROUGH_OVER	1.0		// pen > armor tier: full damage through
#define PEN_PASSTHROUGH_SAME	0.2		// pen == armor tier: 20% damage through
// pen < armor tier: fully blocked (0 through)
// 0.2 is calculated from 55 AP + 30 damage spear = 5 damage through on 80 plate (stab), 5 / 30 = 0.166, rounded up to 0.2. This somewhat matches old system behavior.


// Damage percentage where the type breaks.
#define INTEG_FAILURE 0.1 // 10%


/*===========================================\
||									  		||
||		ARMOR / WEAPON REFERENCE GRAPH	  	||
|| (a general idea where to set integrity)	||
||								  			||
\===========================================*/

// For now. Steel vs Iron will be a difference of 75% integrity without rating differences.
// So Iron will actually be pretty decent and there shouldn't be a compulsive need to upgrade.

/*====================================================================================================
||					|| 	    HELMET		||	    CHEST		||	     ARMS		||	     LEGS		||
======================================================================================================
|| GOLD				||	 5/10			||	 5/10			||	 5/10			||	  5/10			||
|| CLOTH			||	 100/200/300	||	 100/200/300	||	 100/200/300	||	  100/200/300	||
|| LEATHER 			||	 200/250/300	||	 200/250/300	||	 200/250/300	||	  200/250/300	||
|| BRONZE			||	 350/450		||	 350/550		||	 350			||	  350			||
|| IRON				||	 225/300		||	 225/325/375	||	 225			||	  225/300		||
|| BRIGANDINE		||	 200/250		||	 200/250		||	 200/250		||	  200/250		||
|| STEEL			||	 300/400		||	 300/450/500	||	 300			||	  300/400		||
|| BLACKSTEEL		||	 500			||	 600			||	 400			||	  500			||
|| ANTAG-GEAR		||	 600			||	 700			||	 500			||	  600			||
======================================================================================================
(Values after slashes are for light, medium, and heavy variants of the same material, if present.)  */


/* 
Integrity modification defines, use these when the object has one of the features below.
Yes we could just use a lower/higher tier, but this makes it clear WHY we're reducing/increasing integrity.
Do NOT use these on objects with integrity lower than or equal to 10/25/50/100 respectively to avoid potential issues.
*/

// Reduction
#define INT_BRITTLE_MALUS 25		// For some gear cases, like iron.
#define INT_COVERAGE_MALUS 50		// Covers more of the body without a real downside, think Scalemail and Mailled Hauberks.
#define INT_ADJUSTABLE_MALUS 50 	// Simulates weakpoints from hinges or whatever.
#define INT_DECREPIT_MALUS 100 		// Old-ass rusty gear.
#define INT_PSYDONIC_MALUS 100		// Free training, less int.

// Addition
#define INT_TEMPERED_BONUS 25		// Worse version of Reinforced.
#define INT_BRONZE_BONUS 50			// Bonus integrity for worse protection.
#define INT_REINFORCED_BONUS 50		// Bonus integrity for some armor.

/*============================\
||							 ||
||  INTEGRITY MACRO DEFINES	 ||
||							 ||
\============================*/

// Makes it easy to scale integrity to account for balance without an absurd amount of defines or static integers.

/*
Zero integrity define, self-explanatory.
Usually for objects that shouldnt break, like certain walls, doors, gates, props, etc.
*/
#define INT_TIER_NONE 0


/*
Low integrity define macro, step size of 5.
For objects that should be easily damaged.
Example;
INT_TIER_LOW(1) = 5
INT_TIER_LOW(2) = 10
INT_TIER_LOW(3) = 15
*/
#define INT_TIER_LOW(n) (5 + ((n - 1) * 5))


/* 
Medium integrity defines, step size of 25.
Probably for most objects in the game.
Example;
INT_TIER_MEDIUM(1) = 25
INT_TIER_MEDIUM(2) = 50
INT_TIER_MEDIUM(3) = 75
*/
#define INT_TIER_MEDIUM(n) (25 + ((n - 1) * 25))


/* 
High integrity defines, step size of 100.
Use for durable objects, like weapons and armor.
Example;
INT_TIER_HIGH(1) = 100
INT_TIER_HIGH(2) = 200
INT_TIER_HIGH(3) = 300
*/
#define INT_TIER_HIGH(n) (100 + ((n - 1) * 100))


/* 
Ultra integrity defines, step size of 500.
Use sparingly for exceedingly durable objects, avoid using on armor and weapons.
Example;
INT_TIER_ULTRA(1) = 500
INT_TIER_ULTRA(2) = 1000
INT_TIER_ULTRA(3) = 1500
*/
#define INT_TIER_ULTRA(n) (500 + ((n - 1) * 500))


/*============================\
||							 ||
||		 ARMOR DEFINES		 ||
||							 ||
\============================*/

/*-----------\
| MISC ARMOR |
\-----------*/

// These are here just in case and are inherited by their relevant subtypes.
#define ARMOR_MACHINERY list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_MEDIUM, "acid" = DR_HEAVY)
#define ARMOR_STRUCTURE list("blunt" = DR_NONE, "slash" = DBLOCK_NONE, "stab" = DBLOCK_NONE, "piercing" = DBLOCK_NONE, "fire" = DR_MEDIUM, "acid" = DR_MEDIUM)
#define ARMOR_DISPLAYCASE list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_NONE, "fire" = DR_HEAVY, "acid" = DR_ULTRA)
#define ARMOR_CLOSET list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_HEAVY, "acid" = DR_HEAVY)
#define ARMOR_BLACKBAG list("blunt" = DR_ULTRA, "slash" = DBLOCK_BLACKSTEEL, "stab" = DBLOCK_BLACKSTEEL, "piercing" = DBLOCK_BLACKSTEEL, "fire" = DR_SUPER, "acid" = DR_ULTRA)

/*------------\
| LIGHT ARMOR |
\------------*/

// CLOTHING: Clothing, no real protection.
#define ARMOR_CLOTHING list("blunt" = DR_NONE, "slash" = DBLOCK_NONE, "stab" = DBLOCK_NONE, "piercing" = DBLOCK_NONE, "fire" = DR_NONE, "acid" = DR_NONE)

// BAD PADDED: Worse version of padded.
#define ARMOR_PADDED_BAD list("blunt" = DR_MEDIUM, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE)

// PADDED: Best Blunt protection, Bodkin immune. But Axe CHOP (MEDIUM) and sword thrust (MEDIUM) get through. 
#define ARMOR_PADDED list("blunt" = DR_ULTRA, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_BLACKSTEEL, "fire" = DR_MEDIUM, "acid" = DR_NONE)

// LEATHER: Decent Blunt DR. Axe CHOP blocked, but sword thrust (MEDIUM) and bodkin (HEAVY) get through. Better vs slash than padded, worse vs piercing.
#define ARMOR_LEATHER list("blunt" = DR_HEAVY, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)

// Iconoclast dragon skin. Fire resistant.
#define ARMOR_DRAGONSKIN list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_MEDIUM, "fire" = DR_HEAVY, "acid" = DR_NONE)

// Snowflake armor for dragonhide - a bit worse than hard leather but w/ decent fire resist
#define ARMOR_DRAGONHIDE list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_HEAVY, "acid" = DR_NONE)

// BRIGANDINE: Better blunt padding than plate, but arrows punch through.
#define ARMOR_BRIGANDINE list("blunt" = DR_MEDIUM, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "acid" = DR_NONE)

/*-------------\
| MEDIUM ARMOR |
\-------------*/

// MAILLE: Plate level protection but weak vs Bodkin (100% through)
#define ARMOR_MAILLE list("blunt" = DR_LIGHT, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "acid" = DR_NONE)

/*------------\
| HEAVY ARMOR |
\------------*/

// PLATE: Spear (PEN_HEAVY) gets 20% through stab. Bodkin goes through 20% - HEAVY rating. Weak vs Blunt. 
// Brigandine, cuirass, plate. All plate-tier items; differentiated by integrity, not rating. 
#define ARMOR_PLATE list("blunt" = DR_LIGHT, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_HEAVY, "fire" = DR_NONE, "acid" = DR_NONE)

// BLACKSTEEL: Blacksteel, antagonist. DBLOCK_BLACKSTEEL (4).
// Halfsword (PEN_BLACKSTEEL) gets 20% through. Blunt still works decently (DR_MEDIUM only).
#define ARMOR_PLATE_BSTEEL list("blunt" = DR_MEDIUM, "slash" = DBLOCK_BLACKSTEEL, "stab" = DBLOCK_BLACKSTEEL, "piercing" = DBLOCK_BLACKSTEEL, "fire" = DR_MEDIUM, "acid" = DR_MEDIUM)

/*--------------\
| SPECIAL ARMOR |
\--------------*/

// Avoid adding to this unless ABSOLUTELY necessary to reduce armor bloat and keep armor reasonable and intuitive.
#define ARMOR_REGENERATING_BROKEN list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE)

#define ARMOR_VAMP list("blunt" = DR_ULTRA, "slash" = DBLOCK_BLACKSTEEL, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_HEAVY, "fire" = DR_NONE, "acid" = DR_NONE)
#define ARMOR_WWOLF list("blunt" = DR_SUPER, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_MEDIUM, "acid" = DR_NONE)

#define ARMOR_GNOLL_WEAK list("blunt" = DR_ULTRA, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_GNOLL_STANDARD list("blunt" = DR_SUPER, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_GNOLL_STRONG list("blunt" = DR_MEDIUM, "slash" = DBLOCK_BLACKSTEEL, "stab" = DBLOCK_BLACKSTEEL, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)

#define ARMOR_BLACKOAK list("blunt" = DR_ULTRA, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_BLACKSTEEL, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "acid" = DR_NONE) // Wood: great vs blunt/stab, bad vs slash
#define ARMOR_INDESTRUCTIBLE list("blunt" = DR_ULTRA, "slash" = DBLOCK_BLACKSTEEL, "stab" = DBLOCK_BLACKSTEEL, "piercing" = DBLOCK_BLACKSTEEL, "fire" = DR_ULTRA, "acid" = DR_ULTRA) // Magical / indestructible items
#define ARMOR_BUCKET list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_NONE, "fire" = DR_HEAVY, "acid" = DR_SUPER) // It's a bucket. On your head.
