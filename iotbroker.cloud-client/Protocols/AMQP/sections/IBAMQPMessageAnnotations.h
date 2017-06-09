//
//  IBAMQPMessageAnnotations.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPMessageAnnotations : NSObject <IBAMQPSection>

@property (strong, nonatomic) NSMutableDictionary<id, NSObject *> *annotations;

- (void) addAnnotation : (id) key value : (NSObject *) object;

@end
