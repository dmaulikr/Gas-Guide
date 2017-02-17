//
//  AppDelegate.h
//  GasGuide
//
//  Created by JCB on 2/15/17.
//  Copyright © 2017 Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
@property (strong, nonatomic) SWRevealViewController *viewController;

@end

