//
//  AppDelegate.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 01.12.16.
//  Copyright © 2016 MobiusSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

