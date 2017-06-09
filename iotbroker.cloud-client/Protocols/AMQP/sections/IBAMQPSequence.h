//
//  IBAMQPSequence.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"

@interface IBAMQPSequence : NSObject <IBAMQPSection>

@property (strong, nonatomic) NSMutableArray *sequence;

- (void) addSequence : (NSArray *) sequences;

@end
