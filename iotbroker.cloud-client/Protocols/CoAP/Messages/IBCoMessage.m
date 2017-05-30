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

#import "IBCoMessage.h"

@implementation IBCoMessage
{
    NSMutableDictionary *_optionDictionary;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_optionDictionary = [NSMutableDictionary dictionary];
        self->_version = 1;
    }
    return self;
}

+ (instancetype) method : (IBCoAPMethods) method confirmableFlag : (BOOL) isCon tokenFlag : (BOOL) isToken andPayload : (NSString *) payload {
    return [[IBCoMessage alloc] initWithMethod:method confirmableFlag:isCon tokenFlag:isToken andPayload:payload];
}

- (instancetype) initWithMethod : (NSInteger) method confirmableFlag : (BOOL) isCon tokenFlag : (BOOL) isToken andPayload : (NSString *) payload {
    self = [self init];
    if (self != nil) {
        self->_code = method;
        self->_type = (isCon == true) ? IBConfirmableType : IBNonConfirmableType;
        self->_isTokenExist = isToken;
        self->_payload = payload;
    }
    return self;
}

- (NSInteger)getMessageType {
    return self->_type;
}

- (NSInteger)getLength {
    return 0;
}

- (void) addOption : (IBCoAPOptionDefinitions) option withValue : (NSString *) value {
    
    NSMutableArray *values = [NSMutableArray array];
    NSString *key = [@(option) stringValue];
    
    if ([self->_optionDictionary valueForKey:key]) {
        values = [self->_optionDictionary valueForKey:key];
    } else {
        [self->_optionDictionary setValue:values forKey:key];
    }
    
    [values addObject:value];
}

- (NSDictionary *) optionDictionary {
    return self->_optionDictionary;
}

@end
