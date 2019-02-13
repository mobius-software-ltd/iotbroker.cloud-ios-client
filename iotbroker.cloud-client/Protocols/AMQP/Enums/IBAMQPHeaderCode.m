/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

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
