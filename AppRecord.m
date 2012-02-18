#import "AppRecord.h"

@implementation AppRecord

@synthesize appURLString,imageString;
- (void)dealloc
{
    [appURLString release];
       [super dealloc];
}

@end

