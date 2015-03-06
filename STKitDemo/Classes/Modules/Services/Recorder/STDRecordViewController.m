//
//  STDRecordViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDRecordViewController.h"
#import <STKit/STKit.h>
#import "STWaveBarView.h"
#import "STDAboutAudioViewController.h"
#import "SCSiriWaveformView.h"

@interface STDRecordViewController ()


@property (nonatomic, strong) STWaveBarView   * waveBarView;

@property (nonatomic, strong) SCSiriWaveformView    * waveSiriView;

@property (nonatomic, copy) NSString * path;

@property (nonatomic, strong) STLinkLabel     * linkLabel;

@end

@implementation STDRecordViewController

- (void) dealloc {
    [[STAudioCenter sharedAudioCenter] finishRecord];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString * name = [NSString stringWithFormat:@"%lli.caf",(long long int)[[NSDate date] timeIntervalSince1970]];
        NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
        self.path = path;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"正在录音";
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关于" target:self action:@selector(aboutActionFired:)];
    
    self.waveBarView = [[STWaveBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    self.waveBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.waveBarView.channels = 2;
    self.waveBarView.waveStyle = SWaveStyleMedia;
    [self.view addSubview:self.waveBarView];
    [self.waveBarView setInterfaceOrientation:self.interfaceOrientation];
    
    self.waveSiriView = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 100, self.view.width, 100)];
    self.waveSiriView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.waveSiriView.backgroundColor = [UIColor clearColor];
    self.waveSiriView.waveColor = [UIColor whiteColor];
    self.waveSiriView.primaryWaveLineWidth = 2.0;
    self.waveSiriView.secondaryWaveLineWidth = 1;
    self.waveSiriView.frequency = 1.0;
    
    [self.view addSubview:self.waveSiriView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak STDRecordViewController * recordViewController = self;
    [[STAudioCenter sharedAudioCenter] startRecordWithPath:self.path handler:^(STAudioRecorderState state, id userInfo, NSError *error) {
        if (state == STAudioRecorderProgressed) {
            CGFloat averagePower = [[userInfo valueForKey:STAudioRecorderKeyAveragePower] floatValue];
            CGFloat normalizedValue = pow (10, averagePower * 0.05);
            [self.waveSiriView updateWithLevel:normalizedValue];
        }
    } dataHandler:^(AudioQueueBufferRef buffer, NSError *error) {
        [recordViewController.waveBarView appendDataWithAudioBuffer:buffer];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[STAudioCenter sharedAudioCenter] finishRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) aboutActionFired:(id) sender {
    STDAboutAudioViewController * aboutViewController = [[STDAboutAudioViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:aboutViewController animated:YES];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.waveBarView setInterfaceOrientation:toInterfaceOrientation];
}

@end
