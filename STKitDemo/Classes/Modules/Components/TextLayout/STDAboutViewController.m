//
//  STDAboutViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDAboutViewController.h"

#import <STKit/STKit.h>
#import <MessageUI/MessageUI.h>

@interface STDAboutViewController () <MFMailComposeViewControllerDelegate, STLinkLabelDelegate>

@property(nonatomic, strong) STLinkLabel *linkLabel;

@property(nonatomic, strong) NSString *horizontalString;
@property(nonatomic, strong) NSString *verticalString;

@end

@implementation STDAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;

        self.verticalString =
            @"\n大家好，我是<link color=\"ff7300\" highlightedColor=\"ffffff\" highlightBackgroundColor=\"aaffff\" "
            @"value=\"技术哥赞一个|赞一个\">@技术哥\ue415\ue415</"
            @"link>"
            @"，欢迎使用STKit。\n\n\tSTKit目前仍然在建设中，未来还需要大量的测试和验证以及各位亲们的帮助，我也开通了自己的博客，以后会坚持分享我的知"
            @"识。\n\n我的邮箱:lovesunstar@sina.com\n我的博客:http://suenblog.duapp.com "
            @"\n\n欢迎大家关注，我会努力贡献的。\n\n再这里先鄙视下我的坑爹队友:<link "
            @"value=\"鄙视王磊|鄙视\">@王磊²</link>，说好的一起写呢，迄今为止没有贡献过任何代码，强烈鄙视，强烈谴责。<link value=\"测试捐钱\" "
            @"href=\"stkit://pay?title=给技术哥捐钱，有钱的捧个钱场，没钱的捧个人场。&price=10000&amount=10000&count=1\">测试捐钱</"
            @"link>\n\nCopyright @2013-2014";
        self.horizontalString = @"大家好，我是<link "
                                @"value=\"技术哥赞一个|赞一个\">@技术哥</"
                                @"link>"
                                @"，欢迎使用STKit。\n\tSTKit目前仍然在建设中，未来还需要大量的测试和验证以及各位亲们的帮助，我也开通了自己的博客，以"
                                @"后会坚持分享我的知识。\n我的邮箱:lovesunstar@sina.com\n我的博客:http://"
                                @"suenblog.duapp.com\n欢迎大家关注，我会努力贡献的。\n再这里先鄙视下我的坑爹队友:<link "
                                @"value=\"鄙视王磊|鄙视\">@王磊</link>，说好的一起写呢，迄今为止没有贡献过任何代码，强烈鄙视，强烈谴责。\nCopyright "
                                @"@2013-2014";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于STKit";

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    }
    self.linkLabel = [[STLinkLabel alloc] initWithFrame:self.view.bounds];
    self.linkLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.linkLabel.backgroundColor = [UIColor clearColor];
    self.linkLabel.textCheckingTypes = STTextCheckingTypeCustomLink | NSTextCheckingTypeLink;
    self.linkLabel.delegate = self;
    self.linkLabel.text = self.verticalString;
    [self.view addSubview:self.linkLabel];
}

- (void)linkLabel:(STLinkLabel *)linkLabel didSelectLinkObject:(STLinkObject *)linkObject {
    NSURL *URL = linkObject.URL;
    if ([[URL scheme] isEqualToString:@"mailto"]) {
        MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
        viewController.navigationBar.tintColor = [UIColor colorWithRGB:0xFF7300];
        [viewController setToRecipients:@[ @"lovesunstar@sina.com" ]];
        [viewController setCcRecipients:@[ @"97676901@qq.com" ]];
        [viewController setBccRecipients:nil];
        [viewController setSubject:@"【STKit】意见反馈"];
        [viewController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0xFF7300]}];
        [viewController
            setMessageBody:[NSString stringWithFormat:@"Dear 技术哥:<br /><br /><br/><span style=\"font-size:14px;\">当前版本 %@</span><br/>",
                                                      [STApplicationContext sharedContext].bundleVersion]
                    isHTML:YES];
        viewController.mailComposeDelegate = self;
        [self presentViewController:viewController animated:YES completion:NULL];
        return;
    }
    if (URL) {
        if ([[STApplicationContext sharedContext] canOpenURL:URL]) {
            [[STApplicationContext sharedContext] openURL:URL];
            return;
        }
        STWebViewController *webViewController = [[STWebViewController alloc] initWithURL:URL];
        [self.customNavigationController pushViewController:webViewController animated:YES];
    } else {
        NSString *value = linkObject.value;
        NSArray *components = [value componentsSeparatedByString:@"|"];
        NSString *message, *title;
        if (components.count > 0) {
            message = components[0];
            if (components.count > 1) {
                title = components[1];
            }
        }
        UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:title otherButtonTitles:nil, nil];
        [alertView showWithDismissBlock:NULL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.linkLabel.text = self.horizontalString;
    } else {
        self.linkLabel.text = self.verticalString;
    }
}

@end
