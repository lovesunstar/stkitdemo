//
//  STDLinkViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-12-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDLinkViewController.h"
#import <MessageUI/MessageUI.h>


@interface STDLinkViewCell : UITableViewCell <STLinkLabelDelegate, MFMailComposeViewControllerDelegate>

+ (UIFont *)preferredLinkLabelFont;

@property (nonatomic, strong) STLinkLabel   *linkLabel;

@end

@implementation STDLinkViewCell
+ (UIFont *)preferredLinkLabelFont {
    static UIFont *font;
    if (!font) {
        font = [UIFont systemFontOfSize:17];
    }
    return font;
}

CGSize const STDLinkViewCellSize = {320, 40};
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, STDLinkViewCellSize.width, STDLinkViewCellSize.height);
        self.linkLabel = [[STLinkLabel alloc] initWithFrame:CGRectMake(5, 5, 310, 30)];
        self.linkLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.linkLabel.font = [[self class] preferredLinkLabelFont];
        self.linkLabel.continueTouchEvent = NO;
        self.linkLabel.delegate = self;
        [self addSubview:self.linkLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void) linkLabel:(STLinkLabel *) linkLabel didSelectLinkObject:(STLinkObject *) linkObject {
    NSURL * URL = linkObject.URL;
    if ([[URL scheme] isEqualToString:@"mailto"]) {
        MFMailComposeViewController * viewController = [[MFMailComposeViewController alloc] init];
        viewController.navigationBar.tintColor = [UIColor colorWithRGB:0xFF7300];
        [viewController setToRecipients:@[@"lovesunstar@sina.com"]];
        [viewController setCcRecipients:@[@"97676901@qq.com"]];
        [viewController setBccRecipients:nil];
        [viewController setSubject:@"【STKit】意见反馈"];
        [viewController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:0xFF7300]}];
        [viewController setMessageBody:[NSString stringWithFormat:@"Dear 技术哥:<br /><br /><br/><span style=\"font-size:14px;\">当前版本 %@</span><br/>", [STApplicationContext sharedContext].bundleVersion] isHTML:YES];
        viewController.mailComposeDelegate = self;
        [self.viewController presentViewController:viewController animated:YES completion:NULL];
        return;
    }
    if (URL) {
        if ([[STApplicationContext sharedContext] canOpenURL:URL]) {
            [[STApplicationContext sharedContext] openURL:URL];
            return;
        }
        STWebViewController * webViewController = [[STWebViewController alloc] initWithURL:URL];
        [self.viewController.customNavigationController pushViewController:webViewController animated:YES];
    } else {
        NSString * value = linkObject.value;
        NSArray * components = [value componentsSeparatedByString:@"|"];
        NSString * message, * title;
        if (components.count > 0) {
            message = components[0];
            if (components.count > 1) {
                title = components[1];
            }
        }
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:title otherButtonTitles:nil, nil];
        [alertView showWithDismissBlock:NULL];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


@end

@interface STDLinkViewController ()

@property (nonatomic, strong) NSMutableArray    *dataSource;

@end

@implementation STDLinkViewController

- (instancetype)initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:2];
        [dataSource addObject:@"大家好，我是<link color=\"ff7300\" highlightedColor=\"ffffff\" highlightBackgroundColor=\"aaffff\" value=\"技术哥赞一个|赞一个\">@技术哥</link>，欢迎使用STKit。\n\n\tSTKit目前仍然在建设中，未来还需要大量的测试和验证以及各位亲们的帮助，我也开通了自己的博客，以后会坚持分享我的知识。\n\n我的邮箱:lovesunstar@sina.com\n我的博客:http://suenblog.duapp.com \n\n欢迎大家关注，我会努力贡献的。\n\n再这里先鄙视下我的坑爹队友:<link value=\"鄙视王磊|鄙视\">@王磊²</link>，说好的一起写呢，迄今为止没有贡献过任何代码，强烈鄙视，强烈谴责。<link value=\"测试捐钱\" href=\"stkit://pay?title=给技术哥捐钱，有钱的捧个钱场，没钱的捧个人场。&price=10000&amount=10000&count=1\">测试捐钱</link>\n\nCopyright @2013-2014"];
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"STLinkLabel";
    [self.tableView registerClass:[STDLinkViewCell class] forCellReuseIdentifier:@"Identifier"];
    self.tableView.tableFooterView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count * 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataSource[indexPath.row / 10];
    STDLinkViewCell *linkViewCell = (STDLinkViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    linkViewCell.linkLabel.text = text;
    return linkViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataSource[indexPath.row / 10];
    CGSize size = [STLinkLabel sizeWithText:text font:[STDLinkViewCell preferredLinkLabelFont] constrainedToSize:CGSizeMake(tableView.width - 10, 9999) paragraphStyle:nil];
    return size.height + 10;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
