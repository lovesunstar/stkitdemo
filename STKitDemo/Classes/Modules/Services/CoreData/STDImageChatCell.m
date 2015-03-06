//
//  STDImageChatCell.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-19.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDImageChatCell.h"
#import <STKit/STKit.h>

#import "STDMessage.h"
#import "STDImage.h"

void trim(NSString * arg0) {
    
}

@implementation STDImageChatCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.chatView.frame = CGRectMake(45, 0, 20, 20);
        NSString * bubbleImageName;
        CGRect contentFrame;
        if ([reuseIdentifier hasSuffix:@"left.identifier"]) {
            bubbleImageName = @"bubble_image_white.png";
            contentFrame = CGRectMake(11, 4, 4, 10);
        } else {
            bubbleImageName = @"bubble_image_green.png";
            contentFrame = CGRectMake(5, 4, 4, 10);
        }
        
        UIImage * bubbleImage = [[UIImage imageNamed:bubbleImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 10, 15) resizingMode:UIImageResizingModeStretch];
        self.bubbleImageView.adjustsImageWhenHighlighted = NO;
        self.bubbleImageView.adjustsImageWhenDisabled = NO;
        self.bubbleImageView.userInteractionEnabled = NO;
        [self.bubbleImageView setBackgroundImage:bubbleImage forState:UIControlStateNormal];
        
        STImageView * contentImageView = [[STImageView alloc] initWithFrame:contentFrame];
        contentImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentImageView.clipsToBounds = YES;
        contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.chatView addSubview:contentImageView];
        [self.chatView bringSubviewToFront:self.bubbleImageView];
        
        self.chatContentView = contentImageView;
    }
    return self;
}

- (void) setMessage:(STDMessage *)message {
    [super setMessage:message];
    STImageView * chatImageView = (STImageView *) self.chatContentView;
    chatImageView.image = [UIImage imageNamed:message.image.imageURL];
}
@end
