//
//  IBAMQPHeaderCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeaderCode.h"

@implementation IBAMQPHeaderCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPOpenHeaderCode)         forKey:@"Open"];
        [self->_dictionary setValue:@(IBAMQPBeginHeaderCode)        forKey:@"Begin"];
        [self->_dictionary setValue:@(IBAMQPAttachHeaderCode)       forKey:@"Attach"];
        [self->_dictionary setValue:@(IBAMQPFlowHeaderCode)         forKey:@"Flow"];
        [self->_dictionary setValue:@(IBAMQPTransferHeaderCode)     forKey:@"Transfer"];
        [self->_dictionary setValue:@(IBAMQPDispositionHeaderCode)  forKey:@"Disposition"];
        [self->_dictionary setValue:@(IBAMQPDetachHeaderCode)       forKey:@"Detach"];
        [self->_dictionary setValue:@(IBAMQPEndHeaderCode)          forKey:@"End"];
        [self->_dictionary setValue:@(IBAMQPCloseHeaderCode)        forKey:@"Close"];
        [self->_dictionary setValue:@(IBAMQPMechanismsHeaderCode)   forKey:@"Mechanisms"];
        [self->_dictionary setValue:@(IBAMQPInitHeaderCode)         forKey:@"Init"];
        [self->_dictionary setValue:@(IBAMQPChallengeHeaderCode)    forKey:@"Challenge"];
        [self->_dictionary setValue:@(IBAMQPResponseHeaderCode)     forKey:@"Response"];
        [self->_dictionary setValue:@(IBAMQPOutcomeHeaderCode)      forKey:@"Outcome"];
        [self->_dictionary setValue:@(IBAMQPPingHeaderCode)         forKey:@"Ping"];
        
    }
    return self;
}

- (instancetype) initWithHeaderCode : (IBAMQPHeaderCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithHeaderCode : (IBAMQPHeaderCodes) type {
    return [[IBAMQPHeaderCode alloc] initWithHeaderCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number unsignedCharValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPHeaderCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
