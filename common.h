/*
 *	common.h
 *	written by Holmes Futrell
 *	use however you want
 */

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 1024


extern int randomInt(int min, int max);
extern float randomFloat(float min, float max);
extern void fatalError(const char *string);
extern void switchWindows(void);
extern int eaglSetContext(void);
extern void iPhonePumpMessages(void);
extern void drawMenu(void);
extern void setAudioSessionStateTrue(void);
