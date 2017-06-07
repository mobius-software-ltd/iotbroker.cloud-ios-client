//
//  IBAMQPTLVList.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVList.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVArray.h"

@implementation IBAMQPTLVList

- (instancetype)init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPList0Type];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
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
