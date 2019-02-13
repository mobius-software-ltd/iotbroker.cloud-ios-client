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

#import "IBAMQPApplicationProperties.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPApplicationProperties

- (IBTLVAMQP *)value {

    IBAMQPTLVMap *map = [[IBAMQPTLVMap alloc] init];
    
    if (self->_properties != nil) {
        map = (IBAMQPTLVMap *)[IBAMQPWrapper wrapMap:self->_properties];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x74];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:map.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    map.constructor = constructor;

    return map;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPApplicationPropertiesSectionCode];
}

- (void) addProperty : (NSString *) key value : (NSObject *) value {
    if (self->_properties == nil) {
        self->_properties = [NSMutableDictionary dictionary];
    }
    [self->_properties setObject:value forKey:key];
}

@end
