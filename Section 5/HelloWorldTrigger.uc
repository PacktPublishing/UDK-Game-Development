// HelloWorldTrigger is a child of Trigger meaning it has
// all of the properties that a Trigger has.
//
// The placeable keyword means we can put it in the world.
class HelloWorldTrigger extends Trigger placeable;

// PostBeginPlay - Called whenever the level is loaded 
//                 and play starts
function PostBeginPlay()
{
	// Calls the parent's (Trigger) function 
	// with the same name
	super.PostBeginPlay();
	
	// Print "Hello world!" to the log window
	`log( "Hello World!");
}
