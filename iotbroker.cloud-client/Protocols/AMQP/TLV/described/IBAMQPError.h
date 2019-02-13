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
#import "IBAMQPErrorCode.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPTLVList.h"

@interface IBAMQPError : NSObject

@property (strong, nonatomic) IBAMQPErrorCode *condition;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic, readonly) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *info;

- (IBAMQPTLVList *) list;
- (void) fill : (IBAMQPTLVList *) list;
- (void) addInfo : (NSString *) key value : (NSObject *) value;

@end
