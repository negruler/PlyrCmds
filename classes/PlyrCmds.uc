//#############################################################################
// PlyrCmds is a mutator for ut99 servers to provide players with useful commands in game chat (Say)
// by preceding the commands with an !. 
//
// The basis for this mutator was taken from the code in AutoTeamBalance by nogginBasher:  
// http://www.unrealadmin.org/forums/showthread.php?t=23777
// It has been expanded to include commands that are usually provided by Nexgen Server Controller by Defrost: 
// http://www.unrealadmin.org/forums/showthread.php?p=136828.  
// A few other useful commands are also included.  
// The code for executing client side commands was heavily inspired by The Black Tutorials-5 by JackGriffin
// https://ut99.org/viewtopic.php?f=6&t=11501 
// Thanks to all three of those authors mentioned for their hard work which helped make this mutator possible.
// 
// Author: snowguy -- negruler@gmail.com
// 
// This code is released under the GPLv3 see the included LICENSE file for details or visit 
// https://www.gnu.org/licenses/gpl-3.0-standalone.html
//
//###############################################################################

class PlyrCmds extends Mutator config(PlyrCmdsv01a);

var config bool bEnableTeamChangeCmds;
var config bool bEnablePlaySpecCmds;
var config bool bEnableMapVoteCmd;
var config bool bEnableExitCmds;
var config bool bEnableConnectCmds;
var config bool bEnableFlushCmd;

function PreBeginPlay( ) 
{
    Level.Game.RegisterMessageMutator( Self );
    
    Log( "#### PlyrCmdsV01a Loaded ####" );
    
    SaveConfig();
}

// Catch messages from spectators:
function bool MutatorBroadcastMessage(Actor Sender, Pawn Receiver, out coerce string Msg, optional bool bBeep, out optional name Type) 
{
	local string sMsg;

	// Only process the message once.
	if (Sender == Receiver && Sender.IsA('Spectator')) 
	{
		sMsg = Mid( Msg, InStr(Msg,":")+1 );
		if( Left( sMsg, 1 ) == "!")
		{
			CheckMessage( sMsg, PlayerPawn(Sender), PlayerPawn( Receiver ) );
		}
	}
	return Super.MutatorBroadcastMessage(Sender,Receiver,Msg,bBeep,Type);
}

// Catch messages from players:
function bool MutatorTeamMessage( Actor Sender, Pawn Receiver, PlayerReplicationInfo PRI, coerce string Msg, name Type, optional bool bBeep ) 
{

	// Only process each message once.
	if( Sender == Receiver && Sender.IsA( 'PlayerPawn' ) ) 
	{ 
		if( Left( Msg, 1 ) == "!" ) 
		{
			CheckMessage( Msg, Sender, PlayerPawn( Receiver ) );
		}
	}
	return Super.MutatorTeamMessage( Sender,Receiver,PRI,Msg,Type,bBeep );
}

//Check to see if message contains a valid command and execute the command
//Return after any command matches and executes to avoid any further message checks 
function CheckMessage( String Msg, Actor Sender, PlayerPawn Receiver ) 
{
    local PlyrCmdsClient pcc;
    
    //Make sure sender is not a spectator or they can change teams as spectator and grab flags
    if( bEnableTeamChangeCmds && Sender.IsA('PlayerPawn') && !Sender.IsA('Spectator') )
    {
		if ( Msg ~= "!R" || Msg ~= "!RED" )
		{
			ChangePlayerToTeam( Sender, 0 );
			return;
		}

		if ( Msg ~= "!B" || Msg ~= "!BLUE" )
		{
			ChangePlayerToTeam( Sender, 1 );
			return;
		}

		if ( Msg ~= "!G" || Msg ~= "!GREEN" )
		{
			ChangePlayerToTeam( Sender, 2 );
			return;
		}

		if ( Msg ~= "!Y" || Msg ~= "!GOLD" || Msg ~= "!YELLOW" ) 
		{
			ChangePlayerToTeam( Sender, 3 );
			return;
		}
		
		//Allow switching to non colored skin in DM for instance but don't allow this in teamgames (probably needs more thought)
		if ( ( Msg ~= "!N" || Msg ~= "!NONE" ) && !Level.Game.bTeamGame )
		{
			ChangePlayerToTeam( Sender, 255 );
			return;
		}
    }
    
    if( bEnablePlaySpecCmds )
    {
		if ( Msg ~= "!S" || Msg ~= "!SPEC" || Msg ~= "!SPECTATE" ) 
		{
			if( Sender.IsA('PlayerPawn') && !Sender.IsA( 'Spectator' ) ) 
			{
				PlayerPawn(Sender).PreClientTravel( ); // not sure if this is actually needed
				PlayerPawn(Sender).ClientTravel( "?OverrideClass=Botpack.CHSpectator",TRAVEL_Relative, False );
				return;
			}
		}

		if ( Msg ~= "!P" || Msg ~= "!PLAY" )
		{
			if( Sender.IsA( 'Spectator' ) ) 
			{
				PlayerPawn(Sender).PreClientTravel( ); // not sure if this is actually needed
				PlayerPawn(Sender).ClientTravel( "?OverrideClass=",TRAVEL_Relative, False );
				return;
			}
		}
    }
    
    if( bEnableMapVoteCmd )
    {
		if( Msg ~= "!V" || Msg ~= "!VOTE" || Msg ~= "!MAPVOTE" ) 
		{
			Level.Game.BaseMutator.Mutate( "bdbmapvote votemenu",PlayerPawn(Sender) );
			return;
		}
    }
    
    if( bEnableExitCmds )
   {
		if( Msg ~= "!QUIT" || Msg ~= "!EXIT" )
		{
			pcc = Spawn( class 'PlyrCmdsClient', PlayerPawn(Sender), , PlayerPawn(Sender).Location );
			
			if( pcc != None )
			{
			pcc.clientcmd( "Exit" );
			}
			pcc.Destroy();
			return;
		}
    }
    
    if( bEnableConnectCmds )
    {
		if( Msg ~= "!LEAVE" || Msg ~= "!BYE" || Msg ~= "!DC" || Msg ~= "!DISCONNECT" )
		{
			pcc = Spawn( class 'PlyrCmdsClient', PlayerPawn(Sender), , PlayerPawn(Sender).Location );
			
			if( pcc != None )
			{
			pcc.clientcmd( "Disconnect" );
			}
			pcc.Destroy();
			return;
		}
		
		if( Msg ~= "!RC" || Msg ~= "!RECONNECT" )
		{
			pcc = Spawn( class 'PlyrCmdsClient', PlayerPawn(Sender), , PlayerPawn(Sender).Location );
			
			if( pcc != None )
			{
			pcc.clientcmd( "Reconnect" );
			}
			pcc.Destroy();
			return;
		}
    }
    
    if( bEnableFlushCmd )
    {
		if( Msg ~= "!F" || Msg ~= "!FLUSH" )
		{
			pcc = Spawn( class 'PlyrCmdsClient', PlayerPawn(Sender), , PlayerPawn(Sender).Location );
			
			if( pcc != None )
			{
			pcc.clientcmd( "Flush" );
			}
			pcc.Destroy();
			return;
		}
    }

}

function ChangePlayerToTeam( Actor Sender, int TeamNum ) 
{
    //Only kill player for changing teams in a team game (need to consider other possible game types here really i.e. && !MH?)
    if( Level.Game.bTeamGame )
    {
		if( PlayerPawn(Sender) != None )
		{
			PlayerPawn(Sender).ChangeTeam( TeamNum );
		}
	}
	else
	{
		if( PlayerPawn(Sender) != None )
		{
			PlayerPawn(Sender).ClientChangeTeam( TeamNum );
			PlayerPawn(Sender).PreClientTravel( );
			
			//this might not be the right way to do it but this does change the player's team and skin color in DeathMatch games
			//better way would be to have client use SetMultiSkin(SkinActor, SkinName, FaceName, TeamNum ) from pawn class?
			//true bItems player's items travel with them 3rd arg
			PlayerPawn(Sender).ClientTravel( "?OverrideClass=", TRAVEL_Relative, True );
		}
	}
}

defaultproperties {
    bEnableTeamChangeCmds=True
    bEnablePlaySpecCmds=True
    bEnableMapVoteCmd=True
    bEnableExitCmds=True
    bEnableConnectCmds=True
    bEnableFlushCmd=True
}