/**
 * This class is used by the player in order to control Pawns in the game world.
 * in addition we add some new functionality for our game
 *
 * Author:    John P. Doran (john@johnpdoran.com)
 */
class PlatformerPlayerController extends PlayerController;

//Update player rotation when walking
/**
 * state PlayerWalking
 * This state was created to represent the player in movement
 * Standing, Walking, Running, Falling, etc.
 */
state PlayerWalking
{
	//Don't call these functions while in this state, they aren't needed
	ignores SeePlayer, HearNoise, Bump;
	
	/**
	 * This handles the current move on the client side. 
	 *
	 * @param fDeltaTime The amount of time in seconds that have passed
	 * @param out_CamLoc What camera's current location will be
	 * @param out_CamRot What camera's current rotation will be
	 * @param out_FOV    What the camera's field of view should be (unchanged)
	 */
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local Vector tempAccel;
		local Rotator CamRotationYaw;
		
		//Make sure we have a Pawn to work with
		if( Pawn == None )
		{
			return;
		}

		// Set where we should be moving
		tempAccel.Y = PlayerInput.aStrafe  * DeltaTime * PlayerInput.MoveForwardSpeed;
		tempAccel.X = PlayerInput.aForward * DeltaTime * PlayerInput.MoveForwardSpeed;
		tempAccel.Z = 0;
      
		// Get the Controller's yaw to transform our movement/accelerations by
		CamRotationYaw.Yaw = Rotation.Yaw; 
		
		// Rotate tempAccel to face the world's orientation
		tempAccel = tempAccel >> CamRotationYaw;
		
		// Inform the Pawn where it should be
		Pawn.Acceleration = tempAccel;
		Pawn.FaceRotation(Rotation,DeltaTime); 

		CheckJumpOrDuck();
	}
   
} // End PlayerWalking state

/**
 * Tells the Pawn what direction to face in
 *
 * @param DeltaTime   The amount of time that has passed in seconds in the last frame
 */
function UpdateRotation( float DeltaTime )
{
	local Rotator DeltaRot, NewRotation;
	
	if(Pawn != None)
	{
		Pawn.SetDesiredRotation(Rotation);
	}
	
	// Calculate delta to be applied on ViewRotation
	DeltaRot.Yaw = PlayerInput.aTurn;
	DeltaRot.Pitch = PlayerInput.aLookUp;

	NewRotation = Rotation;
	
	//Adjust the viewport to where it should be now
	ProcessViewRotation(DeltaTime, NewRotation, DeltaRot);
	//Now set the camera's rotation
	SetRotation(NewRotation);

	//Pawn should not be lopsided
	NewRotation.Roll = Rotation.Roll;

	if(Pawn != None)
	{
		//This is where I will face if I move
		Pawn.FaceRotation(NewRotation, DeltaTime); 
	}
}   

/**
 * Replace functionality with something used in our platformer
 */
exec function NextWeapon() 
{
	if(PlatformerPawn(Pawn) != None)
	{
		PlatformerPawn(Pawn).CamZoomOut();
	}
}

/**
 * Replace functionality with something used in our platformer
 */
exec function PrevWeapon() 
{
	if(PlatformerPawn(Pawn) != None)
	{
		PlatformerPawn(Pawn).CamZoomIn();
	}
}
