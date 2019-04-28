//
//  AppDelegate.h
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (BOOL)isIPad;
+ (CGFloat)navigationHeight;
@end

