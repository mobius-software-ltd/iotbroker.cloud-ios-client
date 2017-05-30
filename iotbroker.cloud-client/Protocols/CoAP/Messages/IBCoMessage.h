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

#import "IBMessage.h"
#import "IBCoEnums.h"

@interface IBCoMessage : NSObject <IBMessage>

@property (assign, nonatomic, readonly) Byte version;

@property (assign, nonatomic) IBCoAPTypes type;

@property (assign, nonatomic) BOOL isTokenExist;
@property (assign, nonatomic) NSInteger token;

@property (assign, nonatomic) IBCoAPMethods code;

@property (assign, nonatomic) NSInteger messageID;
@property (strong, nonatomic) NSString *payload;

@property (assign, nonatomic) BOOL isResponse;

+ (instancetype) method : (IBCoAPMethods) method confirmableFlag : (BOOL) isCon tokenFlag : (BOOL) isToken andPayload : (NSString *) payload;
- (instancetype) initWithMethod : (NSInteger) method confirmableFlag : (BOOL) isCon tokenFlag : (BOOL) isToken andPayload : (NSString *) payload;

- (void) addOption : (IBCoAPOptionDefinitions) option withValue : (NSString *) value;
- (NSDictionary *) optionDictionary;

@end
