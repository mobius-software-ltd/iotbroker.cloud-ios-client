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

typedef NS_ENUM(Byte, IBAMQPHeaderCodes)
{
    IBAMQPProtocolHeaderCode        = 0x08,
    IBAMQPOpenHeaderCode            = 0x10,
    IBAMQPBeginHeaderCode           = 0x11,
    IBAMQPAttachHeaderCode          = 0x12,
    IBAMQPFlowHeaderCode            = 0x13,
    IBAMQPTransferHeaderCode        = 0x14,
    IBAMQPDispositionHeaderCode     = 0x15,
    IBAMQPDetachHeaderCode          = 0x16,
    IBAMQPEndHeaderCode             = 0x17,
    IBAMQPCloseHeaderCode           = 0x18,
    IBAMQPMechanismsHeaderCode      = 0x40,
    IBAMQPInitHeaderCode            = 0x41,
    IBAMQPChallengeHeaderCode       = 0x42,
    IBAMQPResponseHeaderCode        = 0x43,
    IBAMQPOutcomeHeaderCode         = 0x44,
    IBAMQPPingHeaderCode            = 0xff,
};

@interface IBAMQPHeaderCode : NSObject

@property (assign, nonatomic) IBAMQPHeaderCodes value;

- (instancetype) initWithHeaderCode : (IBAMQPHeaderCodes) type;
+ (instancetype) enumWithHeaderCode : (IBAMQPHeaderCodes) type;

- (NSString *) nameByValue;
- (IBAMQPHeaderCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
