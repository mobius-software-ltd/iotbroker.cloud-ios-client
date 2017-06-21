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

#import "IBAMQPReceived.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPReceived

- (IBAMQPTLVList *)list {
    
    IBAMQPTLVList *list = [IBAMQPTLVList alloc];
    
    if (self->_sectionNumber != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapUInt:[self->_sectionNumber unsignedIntValue]]];
    }
    if (self->_sectionOffset != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapULong:[self->_sectionOffset unsignedLongValue]]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x23];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_sectionNumber = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    
    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_sectionOffset = @([IBAMQPUnwrapper unwrapULong:element]);
        }
    }
}

@end
