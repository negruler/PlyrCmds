PlyrCmds is a mutator for ut99 servers to provide players with useful commands in game chat (Say) by preceding the commands with an !. 

---------------------------------------------------------
Commands available in PlyrCmdsV01a:
---------------------------------------------------------
Change teams:
!r, !red 
!b, !blue 
!g, !green 
!y, !gold, !yellow
!n, !none (in non-team games)

Play and Spectate:
!s, !spec, !spectate
!p, !play

Open Mapvote:
!v, !vote, !mapvote

Exit commands: (closes UT completely)
!quit
!exit

Connection commands: (disconnects or reconnects from/to current server)
!leave, !bye, !dc, !disconnect
!rc, !reconnect

Flush command: (same as typing flush in console)
!f, !flush

---------------------------------------------------------
CONFIGURATION:
---------------------------------------------------------
Each category of commands have the ability to be enabled or disabled in PlyrCmdsV01a.ini (default all enabled).
It is recommended to disable any commands that conflict with the same command string provided by other mutators.

[PlyrCmdsV01a.PlyrCmds]
bEnableTeamChangeCmds=True
bEnablePlaySpecCmds=True
bEnableMapVoteCmd=True
bEnableExitCmds=True
bEnableConnectCmds=True
bEnableFlushCmd=True

---------------------------------------------------------
INSTALLATION:
---------------------------------------------------------
Shut down the server

Copy
PlyrCmdsV01a.u, PlyrCmdsV01a.int, and PlyrCmdsV01a.ini
to your ut servers System directory

Copy 
PlyrCmdsV01a.u.uz 
to your servers redirect if it uses one

In the Servers UnrealTournament.ini add the following under the [Engine.GameEngine] section:
ServerPackages=PlyrCmdsV01a

In your servers mutator startup line add the following:
PlyrCmdsV01a.PlyrCmds

Start the server

---------------------------------------------------------
CONTACT:
---------------------------------------------------------
Please feel free to suggest new features or let me know of any bugs that need fixing.
My username is snowguy on ut99.org and unrealadmin.org
You can also email me at this address: negruler@gmail.com

---------------------------------------------------------
CREDITS:
--------------------------------------------------------
The basis of this mutator is taken from code in AutoTeamBalance by nogginBasher:  
http://www.unrealadmin.org/forums/showthread.php?t=23777
It has been expanded to include commands that are usually provided by Nexgen Server Controller by Defrost: 
http://www.unrealadmin.org/forums/showthread.php?p=136828.  A few other useful commands are also
included.  The code for executing client side commands was heavily inspired by The Black Tutorials-5 by JackGriffin
https://ut99.org/viewtopic.php?f=6&t=11501 
Thanks to all three of the authors mentioned for their hard work and any others who may have contributed to those
listed projects all of which helped make this mutator possible.

---------------------------------------------------------
LICENSE:
---------------------------------------------------------
The code is released under the GPLv3 see the included LICENSE file for details or visit https://www.gnu.org/licenses/gpl-3.0-standalone.html