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

#import "IBAMQPDeliveryAnnotation.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPDeliveryAnnotation

- (IBTLVAMQP *)value {

    IBTLVAMQP *map = [[IBTLVAMQP alloc] init];
    
    if (self->_annotations != nil) {
        map = [IBAMQPWrapper wrapMap:self->_annotations];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x71];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:map.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    map.constructor = constructor;

    return map;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_annotations = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPDeliveryAnnotationsSectionCode];
}

- (void) addAnnotation : (id) key value : (NSObject *) object {
    if (self->_annotations != nil) {
        self->_annotations = [NSMutableDictionary dictionary];
    }
    if ([key isKindOfClass:[NSString class]]) {
        [self->_annotations setObject:object forKey:[[IBAMQPSymbol alloc] initWithString:key]];
    } else if ([key isKindOfClass:[NSNumber class]]) {
        [self->_annotations setObject:object forKey:key];
    } else {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
}

@end
