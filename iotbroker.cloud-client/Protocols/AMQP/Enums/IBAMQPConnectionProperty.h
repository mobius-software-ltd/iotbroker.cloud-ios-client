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

typedef NS_ENUM(NSInteger, IBAMQPConnectionProperties)
{
    IBAMQPPlatformConnectionProperty            = 0,
    IBAMQPProductConnectionProperty             = 1,
    IBAMQPQPidClientPidConnectionProperty       = 2,
    IBAMQPQPidClientPpidConnectionProperty      = 3,
    IBAMQPQPidClientProcessConnectionProperty   = 4,
    IBAMQPVersionConnectionProperty             = 5,
};

@interface IBAMQPConnectionProperty : NSObject

@property (assign, nonatomic) IBAMQPConnectionProperties value;

- (instancetype) initWithConnectionProperty : (IBAMQPConnectionProperties) type;
+ (instancetype) enumWithConnectionProperty : (IBAMQPConnectionProperties) type;

- (NSString *) nameByValue;
- (IBAMQPConnectionProperties) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
