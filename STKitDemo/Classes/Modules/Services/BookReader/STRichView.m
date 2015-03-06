//
//  STRichView.m
//  STKitDemo
//
//  Created by SunJiangting on 13-6-5.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STRichView.h"
#import <STKit/STKit.h>
#import <CoreText/CoreText.h>

@interface STRichView ()

@end

@implementation STRichView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.foregroundColor = [[STThemeManager currentTheme] themeValueForKey:@"BookTextColor" whenContainedIn:[self class]];
        self.attributes = [[STThemeManager currentTheme] themeValueForKey:@"BookTextAttributes" whenContainedIn:[self class]];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.foregroundColor = [[STThemeManager currentTheme] themeValueForKey:@"BookTextColor" whenContainedIn:[self class]];
        self.attributes = [[STThemeManager currentTheme] themeValueForKey:@"BookTextAttributes" whenContainedIn:[self class]];
    }
    return self;
}

- (void) setText:(NSString *)text {
    [self willChangeValueForKey:@"text"];
    _text = [text copy];
    [self setNeedsDisplay];
    [self didChangeValueForKey:@"text"];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (!self.text) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    NSDictionary * basicAttributes = self.attributes;
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:basicAttributes];
    [attributes setValue:(id)self.foregroundColor forKey:(id)kCTForegroundColorAttributeName];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(framesetter);
}

@end
