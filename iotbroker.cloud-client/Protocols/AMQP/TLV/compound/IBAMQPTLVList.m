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

#import "IBAMQPTLVList.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVArray.h"

@implementation IBAMQPTLVList

- (instancetype)init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPList0Type];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_list = [NSMutableArray array];
        self->_width = 0;
        self->_count = 0;
        self->_size = 0;
    }
    return self;
}

- (instancetype)initWithType : (IBAMQPType *) type andValue : (NSArray<IBTLVAMQP *> *) value {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_list = [NSMutableArray arrayWithArray:value];
        self->_width = (type.value == IBAMQPList8Type) ? 1 : 4;
        self->_size += self->_width;
        for (IBTLVAMQP *item in self->_list) {
            self->_size += item.length;
        }
        self->_count = self->_list.count;
    }
    return self;
}

- (void) addElement : (IBTLVAMQP *) element {
    if (self->_size == 0) {
        self.constructor.type.value = IBAMQPList8Type;
        self->_width = 1;
        self->_size += 1;
    }
    [self->_list addObject:element];
    self->_count++;
    self->_size += element.length;
    [self update];
}

- (void) setElementWithIndex : (NSInteger) index element : (IBTLVAMQP *) element {
    self->_size -= [self->_list objectAtIndex:index].length;
    [self->_list replaceObjectAtIndex:index withObject:element];
    self->_size += element.length;
    [self update];
}

- (void) addElementWithIndex : (NSInteger) index element : (IBTLVAMQP *) element {
    int diff = (int)(index - self->_list.count);
    do {
        [self addElement:[[IBAMQPTLVNull alloc] init]];
    } while (diff-- > 0);
    [self setElementWithIndex:index element:element];
}

- (void) addToListWithIndex : (NSInteger) index elementIndex : (NSInteger) elementIndex element : (IBTLVAMQP *) element {
    if (self->_count <= index) {
        [self addElementWithIndex:index element:[[IBAMQPTLVList alloc] init]];
    }
    IBTLVAMQP *list = [self->_list objectAtIndex:index];
    if (list.isNull) {
        [self setElementWithIndex:index element:[[IBAMQPTLVList alloc] init]];
    }
    [((IBAMQPTLVList *)[self.list objectAtIndex:index]) addElementWithIndex:elementIndex element:element];
    self->_size += element.length;
    [self update];
}

- (void) addToMapWithIndex : (NSInteger) index key : (IBTLVAMQP *) key value : (IBTLVAMQP *) value {
    if (self->_count <= index) {
        [self addElementWithIndex:index element:[[IBAMQPTLVMap alloc] init]];
    }
    IBTLVAMQP *map = [self->_list objectAtIndex:index];
    if (map.isNull) {
        [self setElementWithIndex:index element:[[IBAMQPTLVMap alloc] init]];
    }
    [((IBAMQPTLVMap *)[self.list objectAtIndex:index]) putElementWithKey:key andValue:value];
    self->_size += key.length + value.length;
    [self update];
}

- (void) addToArrayWithIndex : (NSInteger) index element : (IBTLVAMQP *) element {
    if (self->_count <= index) {
        [self addElementWithIndex:index element:[[IBAMQPTLVArray alloc] init]];
    }
    IBTLVAMQP *array = [self->_list objectAtIndex:index];
    if (array.isNull) {
        [self setElementWithIndex:index element:[[IBAMQPTLVArray alloc] init]];
    }
    [((IBAMQPTLVArray *)[self.list objectAtIndex:index]) addElement:element];
    self->_size += element.length;
    [self update];
}

- (NSMutableData *)data {

    NSMutableData *sizeData = [NSMutableData data];
    
    if (self->_width == 1) {
        [sizeData appendByte:(Byte)self->_size];
    } else {
        [sizeData appendInt:self->_size];
    }
    
    NSMutableData *countBytes = [NSMutableData data];
    
    if (self->_width == 1) {
        [sizeData appendByte:(Byte)self->_count];
    } else {
        [sizeData appendInt:self->_count];
    }
    
    NSMutableData *valueData = [NSMutableData data];
    NSMutableData *tlvData = [NSMutableData data];

    for (IBTLVAMQP *item in self->_list) {
        tlvData = item.data;
        [valueData appendData:tlvData];
    }
    
    NSMutableData *bytes = [NSMutableData data];

    [bytes appendData:self.constructor.data];
    
    if (self->_size > 0) {
        [bytes appendData:sizeData];
        [bytes appendData:countBytes];
        [bytes appendData:valueData];
    }
    
    return bytes;
}

- (NSString *) description {
    NSMutableString *string = [NSMutableString string];
    for (IBTLVAMQP *item in self->_list) {
        [string appendFormat:@"%@\n", [item description]];
    }
    return string;
}

- (void) update {
    if (self->_width == 1 && self.size > 255) {
        self.constructor.type.value = IBAMQPList32Type;
        self->_width = 4;
        self->_size += 3;
    }
}

- (NSMutableData *)value {
    return nil;
}

- (NSInteger)length {
    return self.constructor.length + self->_width + self->_size;
}

@end
