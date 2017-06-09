//
//  IBAMQPFooter.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPFooter : NSObject <IBAMQPSection>

@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *annotations;

- (void) addAnnotation : (NSString *) key value : (NSObject *) value;

@end
