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
#import "IBMQTTEnums.h"
#import "IBMessage.h"
#import "IBWill.h"

@interface IBConnect : NSObject <IBMessage>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *clientID;

@property (readonly, assign, nonatomic) Byte protocolLevel;
@property (assign, nonatomic) BOOL cleanSession;
@property (assign, nonatomic) NSInteger keepalive;

@property (strong, nonatomic) IBWill *will;

- (instancetype) init;
- (instancetype) initWithUsername : (NSString *) username password : (NSString *) password clientID : (NSString *) clientID keepalive : (NSInteger) keepalive cleanSession : (BOOL) isClean andWill : (IBWill *) will;
+ (instancetype) connectWithUsername : (NSString *) username password : (NSString *) password clientID : (NSString *) clientID keepalive : (NSInteger) keepalive cleanSession : (BOOL) isClean andWill : (IBWill *) will;

- (void) setCurrentProtocolLevel : (NSInteger) level;
- (NSString *) getProtocolName;

- (BOOL) isClean;
- (BOOL) isWillFlag;
- (BOOL) isUsernameFlag;
- (BOOL) isPasswordFlag;

@end
