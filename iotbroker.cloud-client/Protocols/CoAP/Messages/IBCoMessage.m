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
    NSMutableArray<IBCoOption *> *_options;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_options = [NSMutableArray array];
        self->_version = 1;
        self->_token = -1;
    }
    return self;
}

+ (instancetype) code : (IBCoAPCodes) code confirmableFlag : (BOOL) isCon andPayload : (NSString *) payload {
    return [[IBCoMessage alloc] initWithCode:code confirmableFlag:isCon andPayload:payload];
}

- (instancetype) initWithCode : (IBCoAPCodes) code confirmableFlag : (BOOL) isCon andPayload : (NSString *) payload {
    self = [self init];
    if (self != nil) {
        self->_code = code;
        self->_type = (isCon == true) ? IBConfirmableType : IBNonConfirmableType;
        self->_payload = [payload dataUsingEncoding:NSUTF8StringEncoding];
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
    IBCoOption *item = [[IBCoOption alloc] initWithNumber:option length:(int)value.length value:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [self->_options addObject:item];
}

- (void) addOption : (IBCoOption *) option {
    [self->_options addObject:option];
}

- (IBCoOption *) option : (IBCoAPOptionDefinitions) option {
    for (IBCoOption *item in self->_options) {
        if (item.number == option) {
            return item;
        }
    }
    return nil;
}

- (NSArray<IBCoOption *> *) options {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sorted = [self->_options sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return sorted;
}

@end
