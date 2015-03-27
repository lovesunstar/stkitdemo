//
//  STDAuthorization.m
//  STKitDemo
//
//  Created by SunJiangting on 13-11-28.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDAuthorization.h"
#import <STKit/STKit.h>
#import <STKit/STNotificationWindow.h>

NSString *const STDAuthorizationKey = @"com.suen.authorzation.key";
static NSString *_authorizatonKey;
static UIWindow *_displayWindow;

@interface STDAuthorization () <STNotificationWindowDelegate>

@property(nonatomic, strong) STNotificationWindow *notificationWindow;

@end

@implementation STDAuthorization

+ (void)load {
    [self standardAuthorization];
}

+ (instancetype)standardAuthorization {
    static dispatch_once_t onceToken;
    static STDAuthorization *_authorization;
    dispatch_once(&onceToken, ^{
        _authorization = [[STDAuthorization alloc] init];
    });
    return _authorization;
}

+ (void)setAuthorizationKey:(NSString *)authorizationKey {
    _authorizatonKey = authorizationKey;
}

+ (NSString *)authorizationKey {
    return _authorizatonKey;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[self class] setAuthorizationKey:STDAuthorizationKey];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(id)sender {
    [[self class] authorizationWithKey:_authorizatonKey authorizationTime:STAutomicAuthorizationDidFinishLaunch];
}

- (void)applicationWillEnterForeground:(id)sender {
    [[self class] authorizationWithKey:_authorizatonKey authorizationTime:STAutomicAuthorizationDidEnterForeground];
}

+ (NSString *)generateSigWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *joinedString = [NSMutableString string];
    NSArray *keys = [dictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *key in keys) {
        id value = [dictionary valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        if ([value isKindOfClass:[NSString class]]) {
            [joinedString appendString:key];
            [joinedString appendString:@"="];
            [joinedString appendString:value];
        }
    }
    return [joinedString copy];
}

+ (void)authorizationWithKey:(NSString *)key authorizationTime:(STAutomicAuthorizationTime)authorizationTime {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *version = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    [parameters setValue:bundle.bundleIdentifier forKey:@"bundle"];
    [parameters setValue:version forKey:@"version"];
    [parameters setValue:@(authorizationTime) forKey:@"authorizationTime"];
    NSString *sig = [self generateSigWithDictionary:parameters];
    if (sig.length > 50) {
        sig = [sig substringWithRange:NSMakeRange(0, 50)];
    }
    [parameters setValue:[sig md5String] forKey:@"sig"];
    [parameters setValue:@([[NSDate date] timeIntervalSince1970]) forKey:@"timestamp"];
    STHTTPOperation *operation = [STHTTPOperation operationWithURLString:@"http://xstore.duapp.com/authorized/auth.action/" HTTPMethod:@"POST" parameters:parameters];
    NSString *const cer = @"MIIE0zCCA7ugAwIBAgIQGNrRniZ96LtKIVjNzGs7SjANBgkqhkiG9w0BAQUFADCByjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2lnbiBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzUwHhcNMDYxMTA4MDAwMDAwWhcNMzYwNzE2MjM1OTU5WjCByjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2lnbiBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvJAgIKXo1nmAMqudLO07cfLw8RRy7K+D+KQL5VwijZIUVJ/XxrcgxiV0i6CqqpkKzj/i5Vbext0uz/o9+B1fs70PbZmIVYc9gDaTY3vjgw2IIPVQT60nKWVSFJuUrjxuf6/WhkcIzSdhDY2pSS9KP6HBRTdGJaXvHcPaz3BJ023tdS1bTlr8Vd6Gw9KIl8q8ckmcY5fQGBO+QueQA5N06tRn/Arr0PO7gi+s3i+z016zy9vA9r911kTMZHRxAy3QkGSGT2RT+rCpSx4/VBEnkjWNHiDxpg8v+R70rfk/Fla4OndTRQ8Bnc+MUCH7lP59zuDMKz10/NIeWiu5T6CUVAgMBAAGjgbIwga8wDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwbQYIKwYBBQUHAQwEYTBfoV2gWzBZMFcwVRYJaW1hZ2UvZ2lmMCEwHzAHBgUrDgMCGgQUj+XTGoasjY5rw8+AatRIGCx7GS4wJRYjaHR0cDovL2xvZ28udmVyaXNpZ24uY29tL3ZzbG9nby5naWYwHQYDVR0OBBYEFH/TZafC3ey78DAJ80M5+gKvMzEzMA0GCSqGSIb3DQEBBQUAA4IBAQCTJEowX2LP2BqYLz3q3JktvXf2pXkiOOzEp6B4Eq1iDkVwZMXnl2YtmAl+X6/WzChl8gGqCBpH3vn5fJJaCGkgDdk+bW48DW7Y5gaRQBi5+MHt39tBquCWIMnNZBU4gcmU7qKEKQsTb47bDN0lAtukixlE0kF6BWlKWE9gyn6CagsCqiUXObXbf+eEZSqVir2G3l6BFoMtEMze/aiCKm0oHw0LxOXnGiYZ4fQRbxC1lfznQgUy286dUV4otp6F01vvpX1FQHKOtw5rDgb7MzVIcbidJ4vEZV8NhnacRHr2lVz2XTIIM6RUthg/aFzyQkqFOFSDX9HoLPKsEdao7WNq";
    
    STNetworkConfiguration *configuration = [[STNetworkConfiguration alloc] init];
    STCertificateItem *item = [STCertificateItem certificateItemWithBase64String:cer];
    if (item) {
        configuration.certificates = @[item];
    }
    configuration.SSLPinningMode = STSSLPinningModeCertificate;
    configuration.allowsAnyHTTPSCertificate = NO;
    operation.configuration = configuration;
    if ([STLocationManager sharedManager].location) {
        NSString *location = [NSString stringWithFormat:@"%lf,%lf", [STLocationManager sharedManager].location.coordinate.longitude, [STLocationManager sharedManager].location.coordinate.latitude];
        [operation addValue:location forHTTPHeaderField:@"User-Location"];
    }
    [[STHTTPNetwork defaultHTTPNetwork] sendHTTPOperation:operation completionHandler:^(STHTTPOperation *operation, id response, NSError *error) {
        [self _handleHTTPOperation:operation response:response error:error];
    }];
}

+ (void)_handleHTTPOperation:(STHTTPOperation *)operation response:(id)response error:(NSError *)error {
    if (error || ![response isKindOfClass:[NSDictionary class]] ||
        !([[response valueForKey:@"denied"] boolValue])) {
        return;
    }
    NSDictionary *responseDict = response;
    /// 拒绝
    NSDictionary *info = [responseDict valueForKey:@"info"];
    NSInteger op = [[info valueForKey:@"operation"] intValue];
    if (operation == STAuthorizationOperationNone) {
        return;
    }
    NSString *title = [info valueForKey:@"title"];
    NSString *message = [info valueForKey:@"message"];
    NSString *cancel = [info valueForKey:@"cancel"];
    NSString *confirm = [info valueForKey:@"confirm"];
    
    if (STGetBitOffset(op, 0)) {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
        [alertView showWithDismissBlock:^(UIAlertView *alertView, NSUInteger dismissIndex) {
        }];
    }
    if (STGetBitOffset(op, 1)) {
        NSMutableDictionary *notificationInfo = [NSMutableDictionary dictionaryWithCapacity:5];
        [notificationInfo setValue:title forKey:STNotificationViewTitleTextKey];
        [notificationInfo setValue:message forKey:STNotificationViewDetailTextKey];
        STNotificationView *notificationView =
        [STNotificationWindow notificationViewWithInfo:notificationInfo];
        [[STDAuthorization standardAuthorization].notificationWindow pushNotificationView:notificationView
                                                                                animated:YES];
    }
}

#pragma mark - STNotificationWindow
- (STNotificationWindow *)notificationWindow {
    if (!_notificationWindow) {
        _notificationWindow = [[STNotificationWindow alloc] init];
        _notificationWindow.notificationWindowDelegate = self;
        _notificationWindow.displayDuration = 20;
    }
    return _notificationWindow;
}
- (void)allNoticationViewDismissed {
    self.notificationWindow = nil;
}

@end
