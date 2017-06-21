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

#import "IBAMQPSectionCode.h"

@implementation IBAMQPSectionCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPHeaderSectionCode)                  forKey:@"header"];
        [self->_dictionary setValue:@(IBAMQPDeliveryAnnotationsSectionCode)     forKey:@"delivery-annotations"];
        [self->_dictionary setValue:@(IBAMQPMessageAnnotationsSectionCode)      forKey:@"message-annotations"];
        [self->_dictionary setValue:@(IBAMQPPropertiesSectionCode)              forKey:@"properties"];
        [self->_dictionary setValue:@(IBAMQPApplicationPropertiesSectionCode)   forKey:@"application-properties"];
        [self->_dictionary setValue:@(IBAMQPDataSectionCode)                    forKey:@"data"];
        [self->_dictionary setValue:@(IBAMQPSequenceSectionCode)                forKey:@"amqp-sequence"];
        [self->_dictionary setValue:@(IBAMQPValueSectionCode)                   forKey:@"amqp-value"];
        [self->_dictionary setValue:@(IBAMQPFooterSectionCode)                  forKey:@"footer"];
    }
    return self;
}

- (instancetype) initWithSectionCode : (IBAMQPSectionCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithSectionCode : (IBAMQPSectionCodes) type {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number unsignedCharValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPSectionCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

- (id)copyWithZone:(NSZone *)zone {
    
    IBAMQPSectionCode *copy = [IBAMQPSectionCode enumWithSectionCode:self.value];
    return copy;
}

@end
