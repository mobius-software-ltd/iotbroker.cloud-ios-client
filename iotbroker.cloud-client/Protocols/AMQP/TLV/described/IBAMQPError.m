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

#import "IBAMQPError.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPError

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_condition = [[IBAMQPErrorCode alloc] init];
        self->_descriptionString = [NSString string];
        self->_info = nil;
    }
    return self;
}

- (IBAMQPTLVList *) list {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self.condition != nil) {
        IBAMQPSymbol *symbol = [[IBAMQPSymbol alloc] initWithString:[self.condition nameByValue]];
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapObject:symbol]];
    }
    if (self.descriptionString != nil) {
        IBAMQPTLVVariable *tst = [IBAMQPWrapper wrapString:self.descriptionString];
        [list addElementWithIndex:1 element:tst];
    }
    if (self.info != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapMap:self.info]];
    }

    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x1D];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    list.constructor = constructor;
    
    return list;
}

- (void) fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            NSString *name = [IBAMQPUnwrapper unwrapSymbol:element].value;
            IBAMQPErrorCode *code = [[IBAMQPErrorCode alloc] init];
            self->_condition.value = [code valueByName:name];
        }
    }
    
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_descriptionString = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_info = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addInfo : (NSString *) key value : (NSObject *) value {
    if (self->_info == nil) {
        self->_info = [NSMutableDictionary dictionary];
    }
    [self->_info setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
