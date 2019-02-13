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
#import "IBMessage.h"

static NSInteger const IBMQTTSNProtocolID = 1;

@interface IBSNConnect : NSObject <IBMessage>

@property (assign, nonatomic) BOOL willPresent;
@property (assign, nonatomic) BOOL cleanSession;
@property (assign, nonatomic) NSInteger protocolID;
@property (assign, nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString *clientID;

- (instancetype) initWithWillPresent : (BOOL) willPresent cleanSession : (BOOL) cleanSession duration : (NSInteger) duration clientID : (NSString *) clientID;

- (BOOL)isWillPresent;
- (BOOL)isCleanSession;

@end
