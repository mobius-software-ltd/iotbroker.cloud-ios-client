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

#import "IBAMQPSASLCode.h"

@implementation IBAMQPSASLCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPOkSASLCode)         forKey:@"ok"];
        [self->_dictionary setValue:@(IBAMQPAuthSASLCode)       forKey:@"auth"];
        [self->_dictionary setValue:@(IBAMQPSysSASLCode)        forKey:@"sys"];
        [self->_dictionary setValue:@(IBAMQPSysPermSASLCode)    forKey:@"sys-perm"];
        [self->_dictionary setValue:@(IBAMQPSysTempSASLCode)    forKey:@"sys-temp"];
    }
    return self;
}

- (instancetype) initWithSASLCode : (IBAMQPSASLCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithSASLCode : (IBAMQPSASLCodes) type {
    return [[IBAMQPSASLCode alloc] initWithSASLCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number shortValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPSASLCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] shortValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
