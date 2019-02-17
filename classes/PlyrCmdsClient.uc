//#############################################################################
// PlyrCmds Clientside class for executing console commands
//
// Author: snowguy -- negruler@gmail.com
//
// The code is released under the GPLv3 see the included LICENSE file for details or visit 
// https://www.gnu.org/licenses/gpl-3.0-standalone.html
//
//##############################################################################

class PlyrCmdsClient extends Actor;

//Call on server execute on client
replication
{
    reliable if( Role == ROLE_Authority )
        clientcmd;
}

simulated function clientcmd( string cmd )
{
    local PlayerPawn pp;
     
    if( Owner != None )
    {
		pp = PlayerPawn( Owner );
	
		if ( pp != None && pp.Player != None && pp.Player.Console != None )
		{
			pp.ConsoleCommand( cmd );
		}
    }
}

defaultproperties {
    RemoteRole=ROLE_SimulatedProxy
    bHidden=true
}

