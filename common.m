/*
  */
#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#include "common.h"
#include "SDL.h"
#include <stdlib.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#include "SDL_uikitappdelegate.h"
#include "SDL_uikitopenglview.h"



/*
	Produces a random int x, min <= x <= max 
	following a uniform distribution
*/
int
randomInt(int min, int max)
{
    return min + rand() % (max - min + 1);
}

/*
	Produces a random float x, min <= x <= max 
	following a uniform distribution
 */
float
randomFloat(float min, float max)
{
    return rand() / (float) RAND_MAX *(max - min) + min;
}


void iPhonePumpMessages()
{
	
 //printf("runloop return %u\n",CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, TRUE));
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, TRUE);
	}


void setAudioSessionStateTrue() {
	OSStatus error = AudioSessionSetActive(false); 
	if (error) printf("\nAudioSessionSetActive (false) failed");
	error = AudioSessionSetActive(true); 
	if (error) printf("\nAudioSessionSetActive (true) failed");
	
}

void
fatalError(const char *string)
{
    printf("%s: %s\n", string, SDL_GetError());
    exit(1);
}

void switchWindows() {
	
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	NSLog(@"switch windows");
    [appDelegate switchTopWindow];
}

int eaglSetContext(void) {
    EAGLContext *context
 = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

if (![EAGLContext setCurrentContext:context]) {
	NSLog(@"Error: Failed to set current openGL context in [Player initWithFrame:]");
	[context release];
	return -1;
}
	return 0;
}
