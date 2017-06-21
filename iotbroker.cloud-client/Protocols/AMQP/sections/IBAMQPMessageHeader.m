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

#import "IBAMQPMessageHeader.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPMessageHeader

- (IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];

    if (self->_durable != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapBOOL:[self->_durable boolValue]]];
    }
    if (self->_priority != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapUByte:[self->_priority shortValue]]];
    }
    if (self->_milliseconds != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapUInt:[self->_milliseconds unsignedIntValue]]];
    }
    if (self->_firstAquirer != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapBOOL:[self->_firstAquirer boolValue]]];
    }
    if (self->_deliveryCount != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapUInt:[self->_deliveryCount longValue]]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x70];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_durable = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_priority = @([IBAMQPUnwrapper unwrapUByte:element]);
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_milliseconds = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (list.list.count > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_firstAquirer = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_deliveryCount = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPHeaderSectionCode];
}

@end
