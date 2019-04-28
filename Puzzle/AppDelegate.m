//
//  AppDelegate.m
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import "AppDelegate.h"
#import "Puzzle-Swift.h"
#import "UIColor+Hex.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromLayerWithLayer:[UIColor getColorLayer]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ImageListViewController alloc] init]];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

+ (BOOL)isIPad {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

+ (CGFloat)navigationHeight {
    if ([AppDelegate isIPad]) {
        return [[UIApplication sharedApplication] statusBarFrame].size.height+50.0;
    }
    if ([UIScreen mainScreen].bounds.size.width > 800.0) {
        return [[UIApplication sharedApplication] statusBarFrame].size.height+44.0;
    }
    return [[UIApplication sharedApplication] statusBarFrame].size.height+32.0;
}

@end
