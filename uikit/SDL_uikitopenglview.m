/*
 SDL - Simple DirectMedia Layer
 Copyright (C) 1997-2009 Sam Lantinga
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 Sam Lantinga
 slouken@libsdl.org
 */

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "SDL_uikitopenglview.h"
#include "common.h"

@interface SDL_uikitopenglview (privateMethods)

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation SDL_uikitopenglview

@synthesize context;

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame \
retainBacking:(BOOL)retained \
rBits:(int)rBits \
gBits:(int)gBits \
bBits:(int)bBits \
aBits:(int)aBits \
depthBits:(int)depthBits \
{
	
	NSString *colorFormat=nil;
	GLuint depthBufferFormat;
	BOOL useDepthBuffer;
	
	if (rBits == 8 && gBits == 8 && bBits == 8) {
		/* if user specifically requests rbg888 or some color format higher than 16bpp */
		colorFormat = kEAGLColorFormatRGBA8;
	}
	else {
		/* default case (faster) */
		colorFormat = kEAGLColorFormatRGB565;
	}
	
	if (depthBits == 24) {
		useDepthBuffer = YES;
		depthBufferFormat = GL_DEPTH_COMPONENT24_OES;
	}
	else if (depthBits == 0) {
		useDepthBuffer = NO;
	}
	else {
		/* default case when depth buffer is not disabled */
		/* 
		 strange, even when we use this, we seem to get a 24 bit depth buffer on iPhone.
		 perhaps that's the only depth format iPhone actually supports
		 */
		useDepthBuffer = YES;
		depthBufferFormat = GL_DEPTH_COMPONENT16_OES;
	}
	
	if ((self = [super initWithFrame:frame])) {
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool: retained], kEAGLDrawablePropertyRetainedBacking, colorFormat, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		/* create the buffers */
		glGenFramebuffersOES(1, &viewFramebuffer);
		glGenRenderbuffersOES(1, &viewRenderbuffer);
		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
		
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
		
		if (useDepthBuffer) {
			glGenRenderbuffersOES(1, &depthRenderbuffer);
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, depthBufferFormat, backingWidth, backingHeight);
			glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
		}
		
		if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
			return NO;
		}
		/* end create buffers */
		[self drawView];
	}
	return self;
}

- (void)setCurrentContext {
	[EAGLContext setCurrentContext:context];
}


- (void)swapBuffers {
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}



- (void)layoutSubviews {
	[EAGLContext setCurrentContext:context];
	
}




- (void)destroyFramebuffer {
	
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if (depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}


-(void) drawView { 
	
	int err= 0;
	glEnable(GL_DITHER);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable dither support: %d", err);
	glEnable(GL_TEXTURE_2D);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable textures: %d", err);
	
	
	glBindTexture(GL_TEXTURE_2D, texture);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not bind texture: %d", err);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set texture minimization filter: %d", err);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set texture magnification filter: %d", err);
	glEnableClientState(GL_VERTEX_ARRAY);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable vertex arrays: %d", err);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable texture vertex arrays: %d", err);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable texture replacement mode: %d", err);
	
	glViewport( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set viewport: %d", err);
	glScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set scissors: %d", err);
	
	glMatrixMode(GL_PROJECTION);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable projection matrix mode: %d", err);
	
	glScalef( 1.0, 1.0, 0);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set Scalef: %d", err);
	
	
	
	glLoadIdentity();
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable projection matrix mode: %d", err);
	glOrthof(0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, -1, 1);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set view matrix: %d", err);
	
	glMatrixMode(GL_MODELVIEW);
	if (err = glGetError())
		fprintf(stderr,"Error: Could not set model view matrix mode: %d", err);
	glLoadIdentity();
	if (err = glGetError())
		fprintf(stderr,"Error: Could not enable projection matrix mode: %d", err);
	
	
}








- (void)dealloc {
	
	[self destroyFramebuffer];
	if ([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}
	[context release];	
	[super dealloc];
	
}

@end
