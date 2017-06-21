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

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, IBAMQPSectionCodes)
{
    IBAMQPHeaderSectionCode                 = 0x70,
    IBAMQPDeliveryAnnotationsSectionCode    = 0x71,
    IBAMQPMessageAnnotationsSectionCode     = 0x72,
    IBAMQPPropertiesSectionCode             = 0x73,
    IBAMQPApplicationPropertiesSectionCode  = 0x74,
    IBAMQPDataSectionCode                   = 0x75,
    IBAMQPSequenceSectionCode               = 0x76,
    IBAMQPValueSectionCode                  = 0x77,
    IBAMQPFooterSectionCode                 = 0x78,
};

@interface IBAMQPSectionCode : NSObject <NSCopying>

@property (assign, nonatomic) IBAMQPSectionCodes value;

- (instancetype) initWithSectionCode : (IBAMQPSectionCodes) type;
+ (instancetype) enumWithSectionCode : (IBAMQPSectionCodes) type;

- (NSString *) nameByValue;
- (IBAMQPSectionCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
