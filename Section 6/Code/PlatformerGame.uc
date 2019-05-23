/**
 * This class sets the needed variables for our particular gametype.
 *
 * Author:    John P. Doran (john@johnpdoran.com)
 */
class PlatformerGame extends SimpleGame;

DefaultProperties
{
	/** 
	 * Override the default classes for the PlayerController and Pawn 
	 * to use ours instead 
	 */
	PlayerControllerClass=class'MyScripts.PlatformerPlayerController'
	DefaultPawnClass=class'MyScripts.PlatformerPawn'
}