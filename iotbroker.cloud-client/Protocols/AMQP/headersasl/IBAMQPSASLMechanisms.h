//
//  IBAMQPSASLMechanisms.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPSASLMechanisms : IBAMQPHeader 

@property (strong, nonatomic, readonly) NSMutableArray<IBAMQPSymbol *> *mechanisms;

- (void) addMechanism : (NSString *) value;

@end
