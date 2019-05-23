/**
 * This class contains the player's physical representation in the world and 
 * the position and rotation of the player's camera. This pawn will have a camera
 * similar in style to an adventure game.
 *
 * Author:    John P. Doran (john@johnpdoran.com)
 */
class PlatformerPawn extends SimplePawn;

//See http://udn.epicgames.com/Three/CodingStandard.html for more information

/** Having () after the variable name exposes the variables to the editor */

/** The distance the camera will be from the player */
var float CamOffsetDistance; 

/** How high the camera will be from the pawn */
var float CamHeight;

/** How close and how far can the camera be */
var float CamMinDistance, CamMaxDistance;

/** How fast will the zooming be (multiplied by delta time) */
var float CamZoomSpeed; //how far to zoom in/out per command

/**
 * Tells the Pawn in what direction it should face. Will only update the Pawn's 
 * rotation when it's moving.
 *
 * @param NewRotation Where the Pawn should face next.
 * @param DeltaTime   The amount of time that has passed in seconds in the last frame
 */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// No need to update the Pawn's rotation until movement
	if (Normal(Acceleration) != vect(0, 0, 0))
	{
		NewRotation = rotator((Normal(Acceleration)));
		NewRotation.Pitch = 0;
			
		//If we aren't there yet, move towards our new rotation
		NewRotation = RLerp(Rotation, NewRotation, 0.1, true);
		SetRotation(NewRotation);
	}
	
}


/**
 * Orbits the camera around the player, using the offset distance or in front 
 * of walls, whichever is closer
 *
 * @param fDeltaTime The amount of time in seconds that have passed
 * @param out_CamLoc What camera's current location will be
 * @param out_CamRot What camera's current rotation will be
 * @param out_FOV    What the camera's field of view should be (unchanged)
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, 
                                    out rotator out_CamRot, out float out_FOV )
{
	local vector HitLoc,HitNorm, Start, End, vCamHeight;

	vCamHeight = vect(0, 0, 0);
	vCamHeight.Z = CamHeight;
	
	Start = Location;
	
	// Set where we want the camera to be using the player controller's rotation
	End = (Location + vCamHeight) - (Vector(Controller.Rotation) * CamOffsetDistance); 
	out_CamLoc = End;

	// Check if the camera would have something in front of it and the player
	/**
		the vec(16,16,16) is for the extent to trace against, think of a box being
	    drawn around the line so that we can tell if it is about to hit the wall 
	    rather than just hit the wall
	*/
	if(Trace(HitLoc, HitNorm, End, Start, false, vect(16,16,16)) != None)
	{
		out_CamLoc = HitLoc + vCamHeight;
	}
	
	// Set the camera slightly above the player
   out_CamRot = rotator((Location + vCamHeight) - out_CamLoc);
   return true;
}

/**
 * Zoom the camera in
 */
simulated function CamZoomIn()
{
	if(CamOffsetDistance > CamMinDistance)
	{
		//Calculation is time-based so we use the DeltaTime
		CamOffsetDistance-= WorldInfo.DeltaSeconds * CamZoomSpeed;
	}
}

/**
 * Zoom the camera out
 */
simulated function CamZoomOut()
{
	if(CamOffsetDistance < CamMaxDistance)
	{
		//Calculation is time-based so we use the DeltaTime
		CamOffsetDistance+= WorldInfo.DeltaSeconds * CamZoomSpeed;
	}
}

DefaultProperties
{
	/** 1 foot = 16 UU (Unreal Units) */
	CamHeight = 64.0
	CamOffsetDistance = 256.0
	
	//Added in section 4
	CamMinDistance = 64.0
	CamMaxDistance = 400.0
	CamZoomSpeed = 2000.0	
	/////////////////
	
	// This is used to light components / actors during the game
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		/* 
		 * Use a spherical harmonical (SH) light to create a better looking secondary lighting result at a cost 
		 * to performance, but as characters are very important it's worth it
		 */
		bSynthesizeSHLight=TRUE
	End Object
	Components.Add(MyLightEnvironment)
	
	// The visual component of our Pawn
	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
		LightEnvironment=MyLightEnvironment;
		Animations=None
		
		// Replace these for a custom character	
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		AnimSets.Add(AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale')
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
	End Object
	Mesh=InitialSkeletalMesh;
	Components.Add(InitialSkeletalMesh); 
}