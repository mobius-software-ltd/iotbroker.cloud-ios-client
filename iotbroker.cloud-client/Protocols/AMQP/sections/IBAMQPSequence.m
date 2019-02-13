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

#import "IBAMQPSequence.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSequence

- (IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_sequence != nil) {
        list = (IBAMQPTLVList *)[IBAMQPWrapper wrapList:self->_sequence];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x76];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_sequence = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapList:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPSequenceSectionCode];
}

- (void) addSequence : (NSArray *) sequences {
    
    if (self->_sequence == nil) {
        self->_sequence = [NSMutableArray array];
    }
    for (NSObject *value in sequences) {
        [self->_sequence addObject:value];
    }
}

@end
