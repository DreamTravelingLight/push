//
//  AppDelegate.m
//  Push
//
//  Created by LinShang on 16/4/6.
//  Copyright © 2016年 LinShang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong)ViewController *view;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.view = [[ViewController alloc] init];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:self.view];
    self.window.rootViewController = na;
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
                                                                            settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                            categories:nil]];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
        NSLog(@"launchOptions : %@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
        
    }
    //判断是否由远程消息通知触发应用程序启动
//    NSLog(@"launchOptions : %@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"badge : %ld",(long)badge);
    if (badge > 0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge --;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }

    
//    如果应用没启动
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }
//    NSLog(@"Payload: %@", userInfo);
    
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark -- 应用运行，此方法调用，将远程消息中的 payload 数据作为参数传递进去
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userinfo : %@",userInfo);
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    
//    NSDictionary *dic = [aps objectForKey:@"alert"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfo" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfo" object:nil userInfo:aps];
    
    
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        localNotification.regionTriggersOnce = YES;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        //            NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //
        //            [alert show];
    }
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self addDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}
-(void)addDeviceToken:(NSData *)deviceToken
{
    NSString *key=@"DeviceToken";
    NSData *oldToken = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    //如果偏好设置中的已存储设备令牌和新获取的令牌不同则存储新令牌并且发送给服务器端
    if (![oldToken isEqualToData:deviceToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:key];
        [self sendDeviceTokenWidthOldDeviceToken:oldToken newDeviceToken:deviceToken];
    }
}

-(void)sendDeviceTokenWidthOldDeviceToken:(NSData *)oldToken newDeviceToken:(NSData *)newToken{
    //注意一定确保真机可以正常访问下面的地址
    NSString *urlStr=@"http://192.168.1.101/RegisterDeviceToken.aspx";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0];
    [requestM setHTTPMethod:@"POST"];
    NSString *bodyStr=[NSString stringWithFormat:@"oldToken=%@&newToken=%@",oldToken,newToken];
    NSData *body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [requestM setHTTPBody:body];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:requestM completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Send failure,error is :%@",error.localizedDescription);
        }else{
            NSLog(@"Send Success!");
        }
        
    }];
    [dataTask resume];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
