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

#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVVariable.h"

@implementation IBAMQPTLVMap

- (instancetype)init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPMap8Type];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_map = [NSMutableDictionary dictionary];
        self->_width = 1;
        self->_size = 1;
        self->_count = 0;
    }
    return self;
}

- (instancetype)initWithType : (IBAMQPType *) type andMap : (NSDictionary<IBTLVAMQP *, IBTLVAMQP *> *) map {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_map = [NSMutableDictionary dictionaryWithDictionary:map];
        self->_width = (type.value == IBAMQPMap8Type) ? 1 : 4;
        self->_size += self->_width;
        for (IBTLVAMQP *key in self->_map.allKeys) {
            self->_size += key.length;
            self->_size += [self->_map objectForKey:key].length;
        }
        self->_count = self->_map.count;
    }
    return self;
}

- (void) putElementWithKey : (IBTLVAMQP *) key andValue : (IBTLVAMQP *) value {
        
    [self->_map setObject:value forKey:key];
    
    self->_size += key.length + value.length;
    self->_count++;
    [self update];
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    for (IBTLVAMQP *key in self->_map.allKeys) {
        [string appendString:[key description]];
        [string appendString:@" : "];
        [string appendString:[[self->_map objectForKey:key] description]];
        [string appendString:@"\n"];
    }
    return string;
}

- (void) update {
    if (self->_width == 1 && self->_size > 255) {
        self.constructor.type.value = IBAMQPMap32Type;
        self->_width = 4;
        self->_size += 3;
    }
}

- (NSMutableData *)data {
    
    NSMutableData *sizeData = [NSMutableData data];

    if (self->_width == 1) {
        [sizeData appendByte:(Byte)self->_size];
    } else {
        [sizeData appendInt:(int)self->_size];
    }
    
    NSMutableData *countData = [NSMutableData data];
    
    if (self->_width == 1) {
        [countData appendByte:(Byte)(self->_count * 2)];
    } else {
        [countData appendInt:(int)(self->_count * 2)];
    }
    
    NSMutableData *valueData = [NSMutableData data];
    
    [self->_map enumerateKeysAndObjectsUsingBlock:^(IBTLVAMQP * _Nonnull key, IBTLVAMQP * _Nonnull obj, BOOL * _Nonnull stop) {
        [valueData appendData:key.data];
        [valueData appendData:obj.data];
    }];
    
    NSMutableData *bytes = [NSMutableData data];

    [bytes appendData:self.constructor.data];
    
    if (self->_size > 0) {
        [bytes appendData:sizeData];
        [bytes appendData:countData];
        [bytes appendData:valueData];
    }
    
    return bytes;
}

- (NSInteger)length {
    return self.constructor.length + self->_width + self->_size;
}

- (NSMutableData *)value {
    return nil;
}

@end
