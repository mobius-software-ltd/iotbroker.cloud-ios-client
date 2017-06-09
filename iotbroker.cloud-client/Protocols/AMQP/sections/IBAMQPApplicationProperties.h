//
//  IBAMQPApplicationProperties.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"

@interface IBAMQPApplicationProperties : NSObject <IBAMQPSection>

@property (strong, nonatomic, readonly) NSMutableDictionary<NSString *, NSObject *> *properties;

- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
