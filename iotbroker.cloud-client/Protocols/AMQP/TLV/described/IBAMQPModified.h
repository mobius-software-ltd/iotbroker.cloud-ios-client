//
//  IBAMQPModified.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPOutcome.h"
#import "IBAMQPState.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPModified : NSObject <IBAMQPOutcome, IBAMQPState>

@property (strong, nonatomic) NSNumber *deliveryFailed;
@property (strong, nonatomic) NSNumber *undeliverableHere;
@property (strong, nonatomic, readonly) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *messageAnnotations;

- (void) addMessageAnnotation : (NSString *) key value : (NSObject *) value;

@end
