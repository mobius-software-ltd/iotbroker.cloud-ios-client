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

#import "IBCountableMessage.h"

@implementation IBCountableMessage

@synthesize packetID = _packetID;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_packetID = [NSNumber numberWithInteger:0];
    }
    return self;
}

- (instancetype) initWithPacketID : (NSInteger) packetID {
    
    self = [super init];
    if (self != nil) {
        self->_packetID = [NSNumber numberWithInteger:packetID];
    }
    return self;
}

- (NSInteger) getLength {
    @throw [NSException exceptionWithName:@"ABSTRACT CLASS ERROR" reason:@"METHOD OF ABSTRACT CLASS WAS CALLED (getLength)" userInfo:nil];
    return 0;
}

- (NSInteger) getMessageType {
    @throw [NSException exceptionWithName:@"ABSTRACT CLASS ERROR" reason:@"METHOD OF ABSTRACT CLASS WAS CALLED (getMessageType)" userInfo:nil];
    return 0;
}

- (NSNumber *)packetID {
    if ([self->_packetID integerValue] == 0) {
        return nil;
    }
    return self->_packetID;
}

- (void)setPacketID:(NSNumber *)packetID {
    self->_packetID = packetID;
    if ([self->_packetID isEqual:[NSNull null]] || self->_packetID == nil) {
        self->_packetID = [NSNumber numberWithInteger:0];
    }
}

@end

// JSON Mapping

@interface IBCountableMessage (JsonMapping)

@property (nonatomic) NSInteger messageType;

@end

@implementation IBCountableMessage (JsonMapping)

@dynamic messageType;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"messageType": @"packet" }];
}

@end
