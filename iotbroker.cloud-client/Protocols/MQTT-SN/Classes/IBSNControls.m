//
//  IBSNControls.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNControls.h"

@implementation IBSNControls

+ (IBSNControls *) decode : (Byte) ctrlByte {
    if (ctrlByte > 3 || ctrlByte < 0)
        @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Invalid Encapsulated message control encoding: %hhu", ctrlByte] userInfo:nil];
    
    return [[IBSNControls alloc] initWithRadius:ctrlByte];
}

+ (Byte) encode : (IBSNRadius) radius {
    Byte ctrlByte = 0;
    ctrlByte |= radius;
    return ctrlByte;
}

- (instancetype) initWithRadius : (IBSNRadius) radius {
    self = [super init];
    if (self != nil) {
        self->_radius = radius;
    }
    return self;
}

@end
