//
//  STWaveBarView.h
//  STKitDemo
//
//  Created by SunJiangting on 13-3-22.
//  Copyright (c) 2013年 sun. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum STWaveStyle {
    SWaveStyleBar,
    SWaveStyleCurve,
    SWaveStyleBezier,
    SWaveStyleMedia,
} STWaveStyle;

/// 模拟window media player
@interface STWaveBarView : UIView {
	GLint               _backingWidth;
	GLint               _backingHeight;
    GLuint              _renderBuffer;
    GLuint              _frameBuffer;
	EAGLContext     *   _context;
}

@property (nonatomic, assign) NSInteger channels;

@property (nonatomic, assign) STWaveStyle waveStyle;

- (void) appendDataWithAudioBuffer:(AudioQueueBufferRef) bufferRef;

- (void) reset;

- (void) setInterfaceOrientation:(UIInterfaceOrientation) orientation;

@end

@interface STWaveBarView (OpenGLES)

@end
