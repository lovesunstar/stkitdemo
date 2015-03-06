//
//  STWaveBarView.m
//  STKitDemo
//
//  Created by SunJiangting on 13-3-22.
//  Copyright (c) 2013年 sun. All rights reserved.
//

#import "STWaveBarView.h"
#import <STKit/STKit.h>
#import <QuartzCore/CADisplayLink.h>

@interface STWaveBarView () {
    CADisplayLink * _displayLink;
    STWaveAnalysis * _analysis;
    NSArray * _frequency;
    
    CFAbsoluteTime _updatedTime;
    
    CGFloat _scaleFactor;
}

@property (nonatomic, strong) NSMutableArray * heightArray;

@end

@implementation STWaveBarView

+ (Class) layerClass {
    return [CAEAGLLayer class];
}

- (void) dealloc {
    if([EAGLContext currentContext] == _context) {
		[EAGLContext setCurrentContext:nil];
	}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_displayLink invalidate];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.heightArray = [NSMutableArray arrayWithCapacity:_frequency.count];
        
        _analysis = [STWaveAnalysis new];
        
        _scaleFactor = self.contentScaleFactor = [[UIScreen mainScreen] scale];

        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@(GL_FALSE), kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
        
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if(!_context || ![EAGLContext setCurrentContext:_context] || ![self createFramebuffer]) {
            return nil;
        }
        
        [self setupView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appliationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        self.backgroundColor = [UIColor blackColor];
        self.channels = 1;
        
        self.waveStyle = SWaveStyleMedia;
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    _analysis.constraintsHeight = frame.size.height - 30;
    
}

- (void) appendDataWithAudioBuffer:(AudioQueueBufferRef) bufferRef {
    if (!bufferRef || bufferRef->mAudioDataByteSize < self.channels * FFT_BUFFER_SIZE) {
        [_displayLink invalidate];
        _displayLink = nil;
        return;
    }
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(paintRunLoop:)];
        _displayLink.frameInterval = 1;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _updatedTime = CFAbsoluteTimeGetCurrent();
    }

    NSData * data = [NSData dataWithBytes:bufferRef->mAudioData length:bufferRef->mAudioDataByteSize];
    NSArray * heights = [_analysis heightForBarWithData:data channels:self.channels constraintsFrequency:_frequency];
    [heights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat old = [[self.heightArray objectAtIndex:idx] floatValue];
        CGFloat new = [obj floatValue];
        /* Decrease the bars if needed */
        [self.heightArray replaceObjectAtIndex:idx withObject:@(MAX(old, new ))];
    }];
}


- (void) reset {
    [self.heightArray removeAllObjects];
    for (int i = 0; i < _frequency.count - 1; i ++) {
        [self.heightArray addObject:@(0.0f)];
    }
}

- (void) drawMediaWithWaveInfo:(NSDictionary *) userInfo {
    if (!_frameBuffer) return;
	[EAGLContext setCurrentContext:_context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);
	glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(0.0f, 1.0f, 0.0f, 0.7f);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat barWidth = width * 0.75 * _scaleFactor / (CGFloat)(_frequency.count - 1);
    CGFloat barMargin =width * 0.25 * _scaleFactor / (CGFloat)(_frequency.count - 1);;
    [self.heightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat barHeight = [obj floatValue] * _scaleFactor;
        CGFloat barLeft = idx * (barMargin + barWidth);
        CGRect frame = CGRectMake(barLeft, 0, barWidth, barHeight);
        GLfloat vertices[] = {
            CGRectGetMinX(frame), CGRectGetMinY(frame),
            CGRectGetMaxX(frame), CGRectGetMinY(frame),
            CGRectGetMaxX(frame), CGRectGetMaxY(frame),
            CGRectGetMinX(frame), CGRectGetMaxY(frame),
        };
        glVertexPointer(2, GL_FLOAT, 0, vertices);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
        
    }];
	glPopMatrix();
	glFlush();
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderBuffer);
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void) paintRunLoop:(id) sender{
    [self drawMediaWithWaveInfo:nil];
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    // 下落高度
    CGFloat t = currentTime - _updatedTime;
    CGFloat fallHeight = 100 * t;
    __block CGFloat totalHeight = 0.0f;
    for (int i = 0; i < self.heightArray.count; i ++) {
        CGFloat barHeight = [[self.heightArray objectAtIndex:i] floatValue];
        
        barHeight -= fallHeight;
        if (barHeight <= 0.0) {
            barHeight = 0.0;
        }
        [self.heightArray replaceObjectAtIndex:i withObject:@(barHeight)];
        totalHeight += barHeight;
    }
    if (totalHeight <= 0.0) {
        [self drawMediaWithWaveInfo:nil];
        [_displayLink invalidate];
        _displayLink = nil;
    }
    _updatedTime = currentTime;
}

- (void) setInterfaceOrientation:(UIInterfaceOrientation) orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _frequency = @[@(0), @(1), @(2), @(3), @(5), @(7), @(10), @(14), @(20), @(28), @(40), @(54), @(74), @(101), @(137), @(187), @(255)];
    } else {
        _frequency = @[@(0),@(2),@(4),@(6),@(8),@(10),@(12),@(14),@(16),@(18),@(20),@(22),@(24),@(26),@(28),@(30),@(32),@(34),@(36),@(38),@(40),@(42),@(44),@(46),@(48),@(50),@(52),@(54),@(56),@(58),@(60),@(62),@(64),@(66),@(68),@(70),@(72),@(75),@(78),@(81),@(85),@(91),@(97),@(103),@(110),@(118),@(127),@(137),@(151),@(164),@(255)];
    }
    [self.heightArray removeAllObjects];
    for (int i = 0; i < _frequency.count - 1; i ++) {
        [self.heightArray addObject:@(0.0f)];
    }
}

- (BOOL) createFramebuffer {
    
	glGenFramebuffersOES(1, &_frameBuffer);
	glGenRenderbuffersOES(1, &_renderBuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderBuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _renderBuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	return YES;
}

- (void) setupView {
	// Sets up matrices and transforms for OpenGL ES
	glViewport(0, 0, _backingWidth, _backingHeight);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0, _backingWidth, 0, _backingHeight, -1.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
	glClearColor(0.0f/255. ,0.0f/255., 0.f/255., 1.0f);
	glEnableClientState(GL_VERTEX_ARRAY);
	
}

- (void) destroyFramebuffer {
	glDeleteFramebuffersOES(1, &_frameBuffer);
	_frameBuffer = 0;
	glDeleteRenderbuffersOES(1, &_renderBuffer);
	_renderBuffer = 0;
	
}

- (void) layoutSubviews {
    [EAGLContext setCurrentContext:_context];
	[self destroyFramebuffer];
	[self createFramebuffer];
    glViewport(0, 0, _backingWidth, _backingHeight);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0, _backingWidth, 0, _backingHeight, -1.0f, 1.0f);
}

- (void) appliationWillResignActive:(id) sender {
    // invalidate displaylink when resign active
    [_displayLink invalidate];
    _displayLink = nil;
	[self destroyFramebuffer];
}

- (void) applicationDidBecomeActive:(id) sender {
    [self createFramebuffer];
    // start the displaylink
}

@end
