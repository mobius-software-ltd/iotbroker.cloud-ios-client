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
#import "IBInternetProtocol.h"
#import "IBMessage.h"
#import "Account+CoreDataClass.h"
#import "Message+CoreDataClass.h"
#import "Topic+CoreDataClass.h"

@protocol IBRequests <NSObject>

@property (strong, nonatomic, readonly) id<IBInternetProtocol> internetProtocol;

@required
- (void) prepareToSendingRequest;
- (void) sendMessage : (id<IBMessage>) message;
- (void) connectionTimeout;

@optional

- (void) connectWithAccount : (Account *) account;
- (void) publishMessage : (Message *) message;
- (void) subscribeToTopic : (Topic *) topic;
- (void) unsubscribeFromTopic : (Topic *) topic;
- (void) pingreq;
- (void) disconnectWithDuration : (NSInteger) duration;

- (id<IBMessage>) getPingreqMessage;

- (void) secureWithCertificatePath : (NSString *) certificate withPassword : (NSString *) password;

@end
