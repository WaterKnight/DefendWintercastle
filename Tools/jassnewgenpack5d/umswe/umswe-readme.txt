//*******************************************************************************//
------------------------------------UMSWE V5.0-------------------------------------
//*******************************************************************************//

//*******************************************************************************//
				Credits

UMSWE Team:
Scio (Godfather, retired Developer)
Starcraftfreak (Port to 1.10, Lead Developer)
PitzerMike (Co-Developer, NewGen Port, WEU Merge)
Vexorian (Co-Developer)

Special thanks to
WC3Campaigns (for hosting)
Quantam (for MPQDraft)
BlacKDicK (for several contributions and his Heavy Locker, which keeps UMSWE quite small)
Cookie (for several contributions)
FyreDaug (for allowing us to include TFTWE features and finding certain limits)
KDEWolf (for the Light Sources pack and his great logo)
PipeDream and the Grimoire team (for this great WE mod platform)

Thanks to all people who made useful suggestions for this tool in the Forums and on IRC.

Special no-thanks to
weaaddar (for permanently regarding UMSWE as crap)

//*******************************************************************************//
				Contact Information

UMSWE Homepage: http://umswe.wc3campaigns.com
Scio: amweiss@adelphia.net
Starcraftfreak: scfreak045@hotmail.com
PitzerMike: PitzerMike@gmx.at

If you request a feature or if you want to make a suggestion, simply post it into
this thread at WC3Campaigns: 
http://www.wc3campaigns.com/forums/showthread.php?s=&threadid=21493
Help requests should go to the thread of the current release of UMSWE. 
Example: Thread Name = UMSWE 5

//*******************************************************************************//
				Disclaimer

The creator of this program is not responsible for any damage done to your computer
or your maps. It has been tested and scanned for viruses, anything that
occurs is your own fault.  All tools included should be used at your own risk.

//*******************************************************************************//
				Description
				
UMSWE is a simple set of edited game data files from the Warcraft III MPQ files.
These files are embedded into a MPQDraft patch, which attaches those files to the
World Editor without modifying the MPQ files.
The UMSWE team edited these files to allow the user to have more power within the 
World Editor. This power does not come without consequences.  Some of the things we
have enabled may cause crashes if used incorrectly.  When used correctly, these new 
features can produce amazing effects.

//*******************************************************************************//
				Requirements

UMSWE requires a valid installation of Warcraft III (either Reign of Chaos or 
The Frozen Throne. The required version of Warcraft III depends on the version of
UMSWE you are using. Take into account that we base UMSWE on the newest available 
version of Warcraft III.

//*******************************************************************************//
				Compatibility

UMSWE is compatible with all custom editors that don't use local files in the
Warcraft III directory.
We guarantee that UMSWE is compatible with WE Unlimited. However there are some
features of WEU, that are not compatible with UMSWE.
WE Unlimited is now officially discontinued.
The author of WEU recommends using UMSWE 5 in favor of WEU.

//*******************************************************************************//

Feel free to edit the UMSWE files to your satisfaction (if you are able to do that).
However, you are not allowed to distribute a modified version of UMSWE without the 
permission of the UMSWE team.

//*******************************************************************************//
				Known Issues

- All events that add a condition (those are marked as Conditional) work only if you 
  convert them to custom text and fix the function reference for the condition (we 
  don't know why, but the World Editor generates an invalid reference).
  Solution: Just rename the condition function to match the reference or vice versa.

- Some imported files will be replaced with the UMSWE version of these files. For
  example AbilityData.slk but there's no good reason to import such modified files
  anyway.
  Solution: Use a MPQ Editor like WinMPQ or Ladik's MPQ Editor to import files.
  	        Working with such external programs is faster anyway.

- When editing the pathability of tiles no-fly automatically includes no-build,
  even if you checked the buildable option of that tile. As a workaround you can
  apply the no-fly bit with the Grimex PathMapper tool when the map is saved. 

//*******************************************************************************//

1) Installation
2) Uninstallation
3) Version History

//*******************************************************************************//

1) Installation

   This version of UMSWE is already part of the latest distributions of the
   Jass NewGen Pack, so you only have to install the NewGen pack.
   Then in the WE you can enable UMSWE in the new UMSWE menu.
   
//*******************************************************************************//

2) Uninstallation

   Disable UMSWE via the UMSWE menu in the WE.

//*******************************************************************************//

3) Version History

   v5.0 :: 03/28/08
    - Ported to a new technology (Grimoire based instead of MPQDraft)
    - Integrated into the Jass NewGen Pack
    - Instead of the multiple versions, UMSWE can now be configured via the WE menu
      Restart the editor after making changes to the configuration
    - Included missing WEU trigger types and functions
    - Included hidden icons and models from WEU
    - Included the Game Interface Project (more options in the game interface dialog)
    - Added tile pathability configuration
    	This allows you to change the buildability, walkability and flyability of tiles
    - Added a 'Custom Script' option to each type in the GUI

   v4.1 :: 09/28/04
   	- Based on Warcraft III 1.18.
   	- Requires:
   	  * RoC 1.18 or higher
   	  * TFT 1.18 or higher

        - Multiple versions of the editor included
          - UMSWE4.1.exe       = Standard Edition
          - UMSWE4.1AU.exe     = All Units Edition (standard editor with all creeps non-tileset specific and all units at once)
          - UMSWE4.1RD.exe     = Regular Doodad Editon (regular doodad scales, doodads are in their category)
          - UMSWE4.1NB.exe     = Newbie Edition (original WE with only the hidden units enabled)

	Appearance:
	  - Fixed invalid icon references

	Terrain Editor:
	  - Fixed the red cliff bug

	Trigger Editor changes:
	  - Fixed a bug with the "Learn Skill" trigger
	  - Added "Learn Skill (takes abilcode)"
	  - Fixed the color presets
	  - Fixed "Trigger - Remove Condition"
	  - Fixed "Trigger - Remove Action"
	  - Added the real function "X of Unit" (GetUnitX)
	  - Added the real function "Y of Unit" (GetUnitY)
	  - Added the unit group function "Unit Group - Create" (CreateGroup)
	  - Added the action "Unit Group - Destroy" (DestroyGroup)
	  - Added several versions of "Unit - Issue Order Targeting An Item"
	  - Added additional versions of the "Unit Group - Issue Order Targeting A Unit/Item/Point/Destructable/No Target" actions
	    that take strings/ordercodes as orders instead of presets.
	      Info: If you want to use the presets, you can still use the old triggers.
	  - Changed a lot of triggers to reference to common.j functions instead of blizzard.j functions.
	      Info: The functionality of the triggers remained untouched.
	      	    Why common.j functions instead of blizzard.j functions?:
	      	    That is quite simple to answer. common.j contains the built-in functions while blizzard.j uses the functions 
	      	    in common.j to define more complex functions, or just functions for the sake of simplicity (the WE uses very 
	      	    much blizzard.j functions). However, there is a lot of functions, that are the same in common.j and blizzard.j 
	      	    save for their names. For the reason that a blizzard.j function has to call another function, they are slower, 
	      	    so using their common.j equivalents saves performance and memory usage in the game (they also increase the thread
	      	    lifespan). You might won't notice any change, but they have to be faster.
	  - Added Custom Script Trigger Calls
	      Info: Read the tutorial to find out how it works.
	  - Added support for trackables:
	      New events: "Trackable - Trackable is Clicked" (TriggerRegisterTrackableHitEvent), 
	                  "Trackable - Cursor is Moved over Trackable" (TriggerRegisterTrackableTrackEvent)
	      New trigger calls (returning trackable): "Trackable - Create Trackable Object" (CreateTrackable), 
	                                               "Event Response - Triggering Trackable" (GetTriggeringTrackable)
	  - Added a lot of group functions (GroupEnumUnitsOfType, GroupEnumUnitsOfTypeCounted, GroupEnumUnitsOfPlayer, GroupEnumUnitsInRect,
	    GroupEnumUnitsInRectCounted, GroupEnumUnitsInRangeOfLoc, GroupEnumUnitsInRangeOfLocCounted, GroupEnumUnitsSelected)
	      Info: These trigger action need the unit name, that is specified in column 6 in UnitUI.slk. You can enter it manually
	            or make use of the new unit name presets.
	  - Added unit name presets
	  - Added null - Presets for all handle-derived types (if such preset didn't exist)
	  - Removed "Create Dialog Button With Hotkey" action, as it was invalid and caused problems
	  - Added the button function "Create Dialog Button With Hotkey" (DialogAddButton)
	  - Edited the descriptions of the real presets to show the value in brackets
	  - Added the real preset "Game started threshold (0.01)" (bj_GAME_STARTED_THRESHOLD)
	  - Added the integer presets "Maximum number of inventory slots (6)" (bj_MAX_INVENTORY), "Maximum number of players (12)" (bj_MAX_PLAYERS)
	    and "Maximum number of player slots (16)" (bj_MAX_PLAYER_SLOTS)
	  - Added the trigger action "Game - Enable/Disable User UI" (EnableUserUI)
	  - Added the trigger action "Unit - Make Ability Permanent" (UnitMakeAbilityPermanent)
	  - Added the unit function "Unit - Create Unit At Offset" (CreateUnit)
	  - Added the unit function "Unit - Create Unit At Location" (CreateUnitAtLoc)
	  - Added the trigger action "Unit - Apply Life Timer (takes buff)" (UnitApplyTimedLife)
	  - Added the trigger action "Player Group - Destroy" (DestroyForce)
	  - Added the force function "Player Group - Create" (CreateForce)
	  - Added the trigger action "Countdown Timer - Destroy" (DestroyTimer)
	  - Added the trigger action "Dialog - Destroy" (DialogDestroy)
	  - Added the gamecache function "Game Cache - Create" (InitGameCache)
	  - Added the trigger action "Item - Pick Every Item In Rect Matching Condition And Do Action" (EnumItemsInRect)
	  - Simplyfied some descriptions
	  - Added the trigger action "Give Item from Hero to Hero" (IssueInstantTargetOrder)
	  - Added the item function "Create Item At Location" (CreateItemLoc)
	  - Added a lot of boolean calls returning the success of an action to a new trigger category "Return Success"
	  - Added the boolean preset bj_isSinglePlayer
	  - Added the scriptcode function "exitwhen (halt loop when)" (exitwhen)
	  - Added the effect functions AddSpecialEffectLoc, AddSpecialEffect, AddSpecialEffectTarget, AddSpellEffectByIdLoc, 
	    AddSpellEffectById, AddSpellEffectTargetById
	  - Added the scriptcode presets "set bj_wantDestroyGroup = true", "loop" and "endloop"
	  - Added the unittype "Tauren" (ConvertUnitType(20))
	  - Added the lightning action "Move Lightning Effect (Advanced)" (MoveLightningEx)
	  - Added the unit action "Force Unit Animation by Index" (SetUnitAnimationByIndex)

   v4.0 :: 9/23/03 (Build 651)
        - Based on Warcraft III 1.12.
        - Requires:
   	      * RoC 1.10 - 1.12
   	      * TFT 1.07 - 1.12

        - Multiple versions of the editor included
          - UMSWE4.exe       = Standard Edition
          - UMSWE4AU.exe     = All Units Edition (standard editor with all creeps non-tileset specific and all units at once)
          - UMSWE4RD.exe     = Regular Doodad Editon (regular doodad scales, doodads are in their category)
          - UMSWE4NB.exe     = Newbie Edition (original WE with only the hidden units enabled)


	Appearance:
	  - Changed the UMSWE logo
	  - Fixed Admiral Proudmoore's icon

	Terrain Editor:
	  - Added steep slopes and higher cliffs

	- Global Max Unit Speed Option max rasied to 65536
        - Global Max Unit Speed Option min lowered to 0
        - Global Min Unit Speed Option max raised to 65536
        - Global Min Unit Speed Option min lowered to 0
        - Global Max Building Speed Option max raised to 65536
        - Global Max Building Speed Option min lowered to 0
        - Global Min Building Speed Option max raised to 65536
        - Global Min Building Speed Option min lowered to 0
        - Global Creep Camp Pathing Cell Option max raised to 65536

	Object Editor changes:
	  Ability Editor:
	    - Missle Speed max raised to 65536
	    - Level max raised to 65536
	    - Level Requirement max raised to 65536
	    - Level Skip max raised to 65536
	    - Casting time max raised to 65536
	    - Cooldown time max raised to 65536
	    - Duration max raised to 65536
	    - Hero Duration time max raised to 65536
	    - Removed almost all data value caps, some numbers can casue serious errors
	    - Added Effects (some call them wrongly buffs)
	      Info: With this you can edit the shards of Blizzard for example.
	            What you shouldn't do with it:
	              Don't assign these "abilities" to units. (makes Warcraft III crash) 
	              Don't create custom abilities based upon these effects. (has no effect)

	            Why aren't they buffs?:
	              Because their IDs always begin with X (XHbz for Blizzard). They are effects, that
	              appear in a certain area or are attached to units. Buff IDs begin with B (BHbd for 
	              Blizzard). Buffs indicate that an unit is affected by an ability (often with an
	              effect, a little icon and a description). An ability can have a buff and an effect
		      at the same time.

	  Doodad Editor:
	    - Cliff Height Limit max rasied to 99999
	    - Minimum Scale max rasied to 99999
	    - Minimum Scale min lowered to 0.000001
	    - Maximum Scale max rasied to 99999
	    - Maximum Scale min lowered to 0.000001
	    - Build Time max rasied to 99999
	    - Repair Time max rasied to 99999
	    - Gold Cost max rasied to 999999
	    - Lumber Cost max rasied to 999999

	  Unit/Item Editor:
	    - Unit Race is now a string
	    - Target As is now a string
	    - Targets Allowed is now a string
	    - Attack 1 Targets is now a string
	    - Attack 2 Targets is now a string
	    - Attack 1 Splash Targets is now a string
	    - Attack 2 Splash Targets is now a string
	    - Unit Classification is now a string
	    - Enabled Custom Team Color for all units
	    - Gold Cost max rasied to 999999
	    - Lumber Cost max rasied to 999999
	    - Gold To Repair Cost max rasied to 999999
	    - Lumber To Repair Cost max rasied to 999999
	    - Repair Time max rasied to 99999
	    - HP max rasied to 999999
	    - HP Regen max rasied to 99999
	    - Mana max rasied to 999999
	    - Mana Regen max rasied to 99999
	    - Starting Mana max rasied to 999999
	    - Scale max rasied to 99999
	    - Scale min lowered to 0.000001
	    - Stock Max max rasied to 99999
	    - Stock Regen max rasied to 99999
	    - Stock Start max raised to 99999
	    - Uses max rasied to 99999
	    - Missle Speed max rasied to 99999
	    - Agility max rasied to 99999
	    - Agilty Per Level max rasied to 99999
	    - Intelligence max rasied to 99999
	    - Intelligence Per Level max rasied to 99999
	    - Strength max rasied to 99999
	    - Strength Per Level max rasied to 99999
	    - Bounty Dice max rasied to 99999
	    - Bounty Bonus max rasied to 99999
	    - Bounty Sides max rasied to 99999
	    - Collision Size max rasied to 99999
	    - Defense max rasied to 99999
	    - Defense Upgrade Bonus max rasied to 99999
	    - Speed max rasied to 65536
	    - Max Speed max rasied to 65536
	    - Min Speed max rasied to 65536
	    - Sight max rasied to 99999
	    - Night Sight max rasied to 99999
	    - Repulse Group max rasied to 99999
	    - Repulse Parameter max rasied to 99999
	    - Repulse Priority max rasied to 99999
	    - Buff Radius max increased to 99999
	    - Move Height max rasied to 99999
	    - Move Height min decreased to -99999
	    - Move Floor max rasied to 99999
	    - Move Floor min decreased to -99999
	    - Points max raised to 999999
	    - Require Water Radius max changed to 999999
	    - Elevation Radius Radius max rasied to 999999
	    - Fog Radius max raised to 999999
	    - Scale max rasied to 99999
	    - Scale min lowered to 0.000001
	    - Occlusion max rasied to 99999
	    - Run max rasied to 99999
	    - Scale max rasied to 99999
	    - Scale min lowered to 0.000001
	    - Selection Z max rasied to 99999
	    - Shadow Height max raised 99999
	    - Shadow W max rasied to 99999
	    - Shadow X max rasied to 99999
	    - Shadow Y max rasied to 99999
	    - Walk max rasied to 99999
	    - Acquire max rasied to 99999
	    - Attack 1 Cooldown max rasied to 99999
	    - Attack 2 Cooldown max rasied to 99999
	    - Attack 1 Damage Loss max rasied to 99999
	    - Attack 2 Damage Loss max rasied to 99999
	    - Attack 1 Dice max rasied to 99999
	    - Attack 2 Dice max rasied to 99999
	    - Attack 1 Damage Plus max rasied to 99999
	    - Attack 2 Damage Plus max rasied to 99999
	    - Attack 1 Damage Sides max rasied to 99999
	    - Attack 2 Damage Sides max rasied to 99999
	    - Attack 1 Damage Upgrade Bonus max rasied to 99999
	    - Attack 2 Damage Upgrade Bonus max rasied to 99999
	    - Attack 1 Damage Full Radius Bonus max rasied to 99999
	    - Attack 2 Damage Full Radius max rasied to 99999
	    - Attack 1 Damage Half Radius max rasied to 99999
	    - Attack 2 Damage Half Radius max rasied to 99999
	    - Attack 1 Damage Quarter Radius max rasied to 99999
	    - Attack 2 Damage Quarter Radius max rasied to 99999
	    - Attack 1 Range max rasied to 99999
	    - Attack 2 Range max rasied to 99999
	    - Attack 1 Range Buff max rasied to 99999
	    - Attack 2 Range Buff max rasied to 99999
	    - Attack 1 Spill Distribution max rasied to 99999
	    - Attack 2 Spill Distribution max rasied to 99999
	    - Attack 1 Spill Radius max rasied to 99999
	    - Attack 2 Spill Radius max rasied to 99999
	    - Attack 1 Target Count max rasied to 99999
	    - Attack 2 Target Count max rasied to 99999
	    - Minimum Attack Radius max rasied to 99999

	  Upgrade Effect Editor:
	    - ALL minimums lowered to -99999 and maximums rasied to 99999

	  Upgrade Editor:
	    - Level max rasied to 99999
	    - Gold Cost max rasied to 999999
	    - Gold Mod max rasied to 999999
	    - Lumber Cost max rasied to 999999
	    - Lumber Mod max rasied to 999999
	    - Time max rasied to 999999
	    - Time Mod max rasied to 999999


	Trigger Editor changes:
	  - Added Multiboard functionality
	      Info: This introduces also two new variable types: Multiboard and Multiboard Item.
	            Before you use the Multiboard Actions you have to create a Multiboard variable.
	            Now you can start working with the multiboard.
	            
	            About the RGBA colors in the actions "Change Color Of Items" and "Change Color Of Item":
	            255 red/green/blue = 100% red/green/blue, 0 red/green/blue = 0% red/green/blue
	            255 alpha = 0% transparency, 0 alpha = 100% transparency
	  - Added boolean function "Leaderboard - Leaderboard Is Displayed" (IsLeaderboardDisplayed)
	  - Added integer function "Leaderbord - Player Count"
	  - Added string function "Leaderboard - Title"
	  - Added unittypes "Dead" (UNIT_TYPE_DEAD) and "Giant" (UNIT_TYPE_GIANT)
	  - Changed "Hero - Learn Skill" to use any type of skill
	  - Added presets for color codes
	      Info: It adds c| to the beginning, but you need to use the preset for r| at the end or add it in 
	            yorself to the text.
	  - Added additional versions of the "Unit - Issue Order Targeting A Unit/Point/Destructable/No Target" actions
	    that take strings/ordercodes as orders instead of presets. 
	      Info: If you want to use the presets, you can still use the old triggers.
	  - Added additional race presets: None, Other, Creep, Commoner, Critter, Naga
	  - Removed TriggerAddCondition and TriggerRemoveCondition because they crashed the World Editor
	  - Added presets for animation names
	  - Added CreateDestructableZ and CreateDeadDestructableZ as actions and as functions that return the
	    created doodad.
	      Info: You have to use the function, if you want to refer to it (i.e.: store the created doodad to a 
	            variable).
	  - Added boolean function "Point matches Point" (CompareLocationsBJ)
	  - Added boolean function "Region matches Region" (CompareRectsBJ)
	  - Added action "Remove Point" (RemoveLocation)
	  - Enabled "Hero Skill" (heroskillcode) as global variable
	      Info: This variable type is just a dummy variable type (basically it's an integer).
	            Blizzards description for those types: Trigger Non-Variable Types - Utility, only used to simplify triggers
	            In UMSWE, these types (if enabled as global) will appear at the bottom of the variable list
	  - Added to the variable names the Jass2 types in brackets
	  - Added the trigger category "Point" and put all related actions/functions into it
	  - Renamed the trigger category "Region" to "Rect"
	  - Added the trigger category "Region"
	  - Changed strings, to match the variable names ("Region" -> "Rect")
	  - Region ADD-IN: Added actions/functions to deal with regions (RegionAddRect, RegionClearRect, RegionAddCell, RegionAddCellAtLoc, 
	    RemoveRegion, RegionClearCell, RegionClearCellAtLoc)
	  - Added the action "Move Location" (MoveLocation)
	  - Added the boolean function "Remove Trigger From Trigger Queue By Index" (QueuedTriggerRemoveByIndex)
	  - Added the integer function "Index of Queued Trigger" (QueuedTriggerGetIndex)
	  - Added the boolean function "Region Contains Coordinates" (IsPointInRegion)
	  - Added the boolean function  "Region Contains Location" (IsLocationInRegion)
	  - Added the boolean function  "Unit Is In Region" (IsUnitInRegion)
	  - Added the rect action "Move Rect to Offset" (MoveRectTo)
	  - Added the rect action "Remove" (RemoveRect)
	  - Added the boolean function "Unit Is In Player Group" (IsUnitInForce)
	  - Added the boolean function "Unit Owned by Player" (IsUnitOwnedByPlayer)
	  - Added mapflags "Fog of War - Hide Terrain" (MAP_FOG_HIDE_TERRAIN), "Fog of War - Map explored" (MAP_FOG_MAP_EXPLORED),
	    "Fog of War - Always visible" (MAP_FOG_ALWAYS_VISIBLE),
	  - Added the player function "Detecting Player" (GetEventDetectingPlayer)
	  - Enabled all TFT triggers on RoC (except the triggers for elevators)
	
	Special:
	  - Added KDEWolfs Light Sources Pack
	    Info: There are static and dynamic light sources.
	          Read the tutorial on how to use them. You can find it in UMSWE Files\Documentation\Light Sources\index.html.

	Misc:
	  - Added All Animation Names.txt
	  - Updated all "All ***.txt" files with TFT information (up to date RoC versions of these files can be found inside the
	    "UMSWE Files\RoC" directory).
	  - Added two tutorials: One for Light Sources and one for Regions. They can be found inside the Documentation folder in the
	    UMSWE Files folder.
	  - War3Config is now bundled with UMSWE. It has some features to easily access all the different versions of UMSWE.

   v3.8 :: 7/16/03
   	- Only the standard editor is released
   	- Fixed various problems:
   	  - Added event "Player - Advanced Events"
   	  - Removed "Triggering Region"

   v3.7 :: 7/15/03
        - Based on Warcraft III 1.10.

        - Multiple versions of the editor included
          - UMSWE3.7.exe       = standard editor
          - UMSWE3.7AC.exe     = standard editor with all creeps non-tileset specific
          - UMSWE3.7RD.exe     = standard editor with regular doodad scales (no massive or tiny ones)
          - UMSWE3.7TM.exe     = combines UMSWE3.7AC.exe and UMSWE3.7RD.exe
          - UMSWE3.7NB.exe     = original WE with only the hidden units enabled (newbie version)

        - Special thanks to Starcraftfreak for making UMSWE work in 1.10

        Trigger Editor changes:
	  - Added presets for Order (ordercode)
	  - Removed the Unit Order for Comparison variable type (didn't work)
	  - Added string presets for SFX Attachpoints
	      Info: Attach Points and Attach Point Modifiers can be connected very easy via 
	            Concatenate Strings. The modifiers already contain a space at the beginning
	            (e.g.: the modifier "left" is stored as " left"). General Info on Attach Points
	            can be found in the file SFX Attach points.txt.
	  - Added the camerafield CAMERA_FIELD_ZOFFSET
          - Removed Unit Enters Region (Conditional) (possibly temporary, but probably wont come back)
          - Removed Unit Leaves Region (Conditional) (possibly temporary, but probably wont come back)
          - Removed {Triggering Region} function, didn't work :-P (thx atRandom)
       	  - Fixed item icons not allowing strings occasionally (thx Cookie)

        Object Editor changes:
          Abilities:
            - Removed level requirement, max level, and level skip caps

          Units:
            - Removed caps for the following fields:
              - Animation - Run/Walk Speed
              - Scaling Value
              - Speed Base, Speed Minimum and Speed Maximum
              - Starting Agility/Strength/Intelligence
              - Sight Radius (Day/Night)

        Misc:
          - Added All Order Strings.txt
	  - Merged the listfiles into one list: war3list.txt.
	    This list contains list for: war3.mpq, War3Patch.mpq, war3x.mpq, war3xlocal.mpq and a 
	    generic W3M list

	Note: If you are using WC3:RoC 1.06 or below, you should use UMSWE 3.6, which is available at
	      http://www.umsmaps.com/files/UMSWE3.6.zip. UMSWE 3.7 and above will only support RoC 1.10 
	      and any version of TFT.

   v3.6 :: 1/26/03
        - Multiple versions of the editor included
          - UMSWE3.6.exe       = standard editor
          - UMSWE3.6AC.exe     = standard editor with all creeps non-tileset specific
          - UMSWE3.6RD.exe     = standard editor with regular doodad scales (no massive or tiny ones)
          - UMSWE3.6TM.exe     = combines UMSWE3.6AC.exe and UMSWE3.6RD.exe
          - UMSWE3.6NB.exe     = original WE with only the hidden units enabled (newbie version)

          
        - Included the following files:
                   - All Path Tex.txt that lists all the pathing textures (Thx Heaven for inspiring)
                   - All Unit Ids.txt that lists all the units and their ID codes

        - Added Get Local Player parameter (Thx for pointing it out DigimonKiller)
        - Fixed the Boolean Condition Region Contains Coordinates (Thx for pointing it out DigimonKiller)
        - Changed Unit Enters Region (Conditional) (Thx for pointing it out Driffin)
        - Changed Unit Leaves Region (Conditional) (Thx for pointing it out Driffin)
        - Changed values of Unit Turn Rate in unit editor (Thx for pointing it out atRandom)
        - Removed height limit for terrain variation and levels (Thx Heaven for inspiring)
        - Enabled Attack 2 only option for Unit Attacks Enabled (Thx for pointing it out atRandom, Blizzard forgot it =P)


   v3.5 :: 12/22/02
        - Multiple versions of the editor included
          - UMSWE3.5.exe       = standard editor
          - UMSWE3.5AC.exe     = standard editor with all creeps non-tileset specific
          - UMSWE3.5RD.exe     = standard editor with regular doodad scales (no massive or tiny ones)
          - UMSWE3.5TM.exe     = combines UMSWE3.5AC.exe and UMSWE3.5RD.exe
          - UMSWE3.5NB.exe     = original WE with only the hidden units enabled (newbie version)

        - Included the following files:
               - All Spell Codes.txt (lists the 4 letter codes for all spells)
               - All Unit Codes.txt (lists the 4 letter codes for all units)
          
        - Put hero abilities into the Item abilities pull down (allows items and units to have lvl 1 hero abilities)
            (They appear above the regular item abilities, Wind Walk is last hero ability.
             If you want the ability to act as it normally does (ie can gain levels) it must be under the
             Her Ability section, otherwise it will only be level 1) Also, some hero abilities 
             crash the game when used as a regular ability, be sure to test the items before releasing to the public)

        - Removed some trigger conditions I had added in for testing but forgot to remove
        - Moved Starfall from Order Targeting Point to Order With No Target
        - Unit enters/leaves region (conditional) event fixed
        - Added Rope Bridge doodad (8 types) (requires adding DestructableData.slk to your map, or running autoimplament.bat)
        - Added the following orders:
                 - Undead Lich - Activate Frost Armor
                 - Undead Lich - Deactivate Frost Armor
                 (Blizzard forgot to add these with the last patch that made it autocast)

   v3.4 :: 12/1/02
        - Multiple versions of the editor included
          - UMSWE3.4.exe       = standard editor
          - UMSWE3.4AC.exe     = standard editor with all creeps non-tileset specific
          - UMSWE3.4RD.exe     = standard editor with regular doodad scales (no massive or tiny ones)
          - UMSWE3.4TM.exe     = combines UMSWE3.4AC.exe and UMSWE3.4RD.exe
          - UMSWE3.4NB.exe     = original WE with only the hidden units enabled (newbie version)

        - Set minumum map size to 32
        - Set maximum map size to 480
              (Note total size restrictions still apply)
        - Set default map size to 32x32
        - Set minimun Day/Night cycle modification to 0.01
        - Set maximum Day/Night cycle modification to 10.0
        - Set max life, mana, life regen, mana regen, gold cost, and lumber cost to 500000
        Thx to Dave:
        - Removed Compare Trigger Condtion
        - Fixed Trigger - Add Action

   v3.3 :: 11/23/02

          YOU MUST DELETE THE FILES FROM THE LAST VERSION IF YOU HAVE IT!

        - Multiple versions of the editor included
          - UMSWE3.3.exe       = standard editor
          - UMSWE3.3AC.exe     = standard editor with all creeps non-tileset specific
          - UMSWE3.3NB.exe     = original WE with only the hidden units enabled (newbie version)

        - Fixed walls rotating in-game due to free rotation in editor
        - Fixed Unit Order Presets
        - Revised section 2 of the readme for clarification
        - Doodads are no longer tileset specific
        - Added a parameter for timers that GU used (for compatability)
        - Added the following actions
          - Game - Display text to single player (auto-timed)
          - Game - Display text to single player

   v3.2 :: 11/16/02
        - Had to revert the events for unit enters and leaves region with condition to the old
              style regions, so u cant use variables with them
        - Destructable doodads can now have the same scales as regular doodads
        - All doodads can now be rotated to any degree
        - Fixed the attack one projectile speed to have the same limits as the other fields
        - Increased max range to 30000
        - Increased max aquisition range to 30000
        - Increased max sight range (day) to 30000
        - Increased max sight range (night) to 30000
        - Unit Classification is now a string

   V3.1 :: 11/9/02
        - Thx to Cookie and BlackDick for help with testing and advice
        - Removed ALL extra unit fields since they do not work correctly
        - Set most maximum values in unit editor to 10000
        - Set most minimum values in unit editor to 0 (including cooldown)
        - Modified BlackDick's Doodad add on, should work now since load order was fixed
        - Added listfiles for war3.mpq, war3patch.mpq, and a generic w3m listfile

   V3.0 :: 11/3/02
        This update is mostly due to BlackDick "Informing" me of my problems by releasing
             his own editor that fixed what I did wrong
        - Added WE hints to almost all the new trigger add ons
        - Added Event ID variable
        - Added Trigger Action variable
        - Added Trigger Condition variable
        - Added Get Event ID parameter
        - Added Region Entered param
        - Added Compare oporators for all the new variable types
        - Added the following actions
          -Trigger - Create Trigger
        - Fixed Add Events (now is a parameter)
        - Fixed Add Action (now is a parameter)
        - Fixed Add Condition (now is a parameter)
          (NOTE: to use these trigger parameters, create a temporary variable that
                 will be used to call the parameters)
                 
          Here is an example:
               Set Variable newTrigger = {Create Trigger}
               Set Variable tempEvent = Trigger - Add Variable Event <Add the following variable event to {newTrigger}: {Variable} Equal To Value>
        -I moved the included text files into their own folder, so u can delete the old ones.

   V2.7 :: 10/25/02
        - Added All AIScripts.txt file
        - Minimum move speed set to 0
        - Fixed Special Effect - Spell Effect At Location
        - Fixed Special Effect - Spell Effect On Unit
        - Added unit order variable
        - Added the presets for order comparison (ALL the orders are there! :))
        - Enabled Trains unit property for heroes and units (Use at your own risk)
        - Enabled Sell Unit unit property for heroes and units (Use at your own risk)
        - Enabled Sell Item unit property for heroes and units (Use at your own risk)
        - Added Attack 1 - Point to unit editor
        - Added Attack 2 - Point to unit editor
        - Added Attack 1 - Backswing to unit editor
        - Added Attack 2 - Backswing to unit editor
        - Fixed Item Icon problem

   V2.6 :: 10/20/02
        - Had to revert the Unit Editor back to old max values, if anything seems wrong let me know
        - Changed Player Leaves event to Player - Advanced Events, and leaves is on a pulldown menu
        - Added the following actions
          -Dialog - Create Dialog Button with Hotkey (GU version) [to make maps compatable]
          -Player - Set Max Number Of Units by Type (Insipired by GU, and used same name for compatability)

   V2.5 :: 10/19/02
        - Removed most maximum values in unit editor
        - Pathing textures are now strings instead of pulldown menus
        - You can now use region variables and functions for things like "Unit Enters Region"
              (The word "Rectangle" now appears where "Region" was in these cases)
        - Added the following events
                -Unit - Unit Enters Region (Conditional)
                -Unit - Unit Leaves Region (Conditional)
                -Unit - Player-Owned Unit Event (Conditional)
        - Added the following conditions
                -Boolean - Timer Dialog is Displayed
        - Added the following actions
                -Dialog - Create Dialog Button With Hotkey
                -Trigger - Add Variable Event
                -Trigger - Add Timer Expires Event
                -Trigger - Add Dialog Event
                -Trigger - Add Dialog Button Clicked Event
                -Trigger - Add Game Event
                -Trigger - Add Unit Enters Region (Conditional) Event
                -Trigger - Add Unit Leaves Region (Conditional) Event
                -Trigger - Add Player Event
                -Trigger - Add Player-Owned Unit Event
                -Trigger - Add Player-Owned Unit Event (Conditional)
                -Trigger - Add Player Property Event
                -Trigger - Add Chat Message Event
                -Trigger - Add Destructible Doodad Dies Event
                -Trigger - Add Unit State Event
                -Trigger - Add Specific Unit Event
                -Trigger - Add Unit In Range Event
                -Trigger - Reset Trigger

   V2.1 :: 10/15/02
        - Fixed the Plague Cloud (Plague Ward) unit icon and name (its the unit that appears after a abom is killed, last for a few seconds infecting anyone that gets near it)
        - Enabled Item abilites for ALL UNITS! :)
        - Added the following conditions
                -Boolean - Unit Race Check (Usually replaced by Race Comparison)
        - Added the following actions
                -Hero - Add Item to Slot by ID (create an item in a certain slot for a unit)
        - Added All Icons.txt(new version)
        - Added All Models.txt (new version)
        - Added SFX Attach Points.txt
        - Minimum move speed reduced to 0

        - Hid all the unit properties that I added that cannot be used until the next patch

        Thx to cookie, I realized that the extra unit properties I added won't work until blizzard
            fixes the load order.  I will continue to add more as I find them, in anticipation of a patch.
            I will however, focus more on new triggers since those will work with the current patch.
            All the old fields will work still even with the changes I made to what goes into them, like 
            the full path for models and icons. The following were added prior to this information but are now also hidden
        
        - Fixed Spill Radius unit attribute (thx WEEB team for the definintion)
        - Fixed Damage Reduction unit attribute (thx WEEB team for the definintion)
        - Added Range Buff for both attacks (number added to range to hit targets moving away from unit. Default is 250 for ALL units who can attack)
        - Added X, Y, Z positions for weapon fire origin
        - Added Vertical Collision Size
        - Added Weapon Sound field
        - Added default atuo-casting fields (which auto-cast spell is initialy on when unit is created)

   V2.0 :: 10/13/02
        - Removed Useless Ancestral Guardian lines
        - Split up neutral hostile units as requested
        - DoomGuard and Infernal are still in all terrain sets (Just cause I like them :))
        - Added the following actions
                -Hero - Set Hero Agility (sets the hero's agility to a specified number)
                -Hero - Set Hero Intelligence (sets the hero's intelligence to a specified number)
                -Hero - Set Hero Strength (sets the hero's strength to a specified number)
                -Unit - Apply life timer (Makes the unit have a life timer like a summoned unit)
                -Special Effect - Create Spell Effect at Location (creates the illusion of a spell)
                -Special Effect - Create Spell Effect on Unit (creates the illusion of a spell)
                -Trigger - Add Condition
                -Trigger - Remove Condition
                -Trigger - Clear Conditions
                -Trigger - Add Action
                -Trigger - Remove Action
                -Trigger - Clear Actions
                (I didn't do add event becasue each would require an entry and there are 91, =/
                   if you really want this let me know otherwise, it probably wont be addded)
        - Added the following events
                -Player - Player leaves (when a player leaves or is disconnected)
        - Added the following unit classifications (for boolean comparison)
                -Snared (effected by web or ensnare abilities)
                -Stunned (effected by bash or similar stunning abilities)
                -Plagued (effected by undead disease cloud)
        - Added the following conditions
                -Region Comparison (Not very useful, but hey what the heck! :))
                -Boolean Region Contains Point (Also not very useful, but good if moving regions)

   V1.5 :: 10/11/02
        - Added a few unit properties to some secions and removed others
        - Moved around where the new unit properties fall
          - The ones I'm still not sure what they do are at the bottom, plz help me test them
          - Some properties may not have an effect on some unit types, ie buildings if you find one tell me
        - Minor changes to things here and there

   V1.0 :: 10/10/02
        - Finished up the starting process, waiting for more input as to what to add

©2002-2003 UMSWE Team. All rights reserved.