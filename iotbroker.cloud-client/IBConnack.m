/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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

#import "IBConnack.h"

@implementation IBConnack

- (instancetype) initWithSessionPresentValue : (BOOL) sessionPresenValue andReturnCode : (IBConnectReturnCode) returnCode {

    self = [super init];
    if (self != nil) {
        self.sessionPresentValue = sessionPresenValue;
        self.returnCode = returnCode;
    }
    return self;
}

+ (instancetype) connackWithSessionPresentValue : (BOOL) sessionPresenValue andReturnCode : (IBConnectReturnCode) returnCode {

    return [[IBConnack alloc] initWithSessionPresentValue:sessionPresenValue andReturnCode:returnCode];
}

- (NSInteger) getLength {
    return 2;
}

- (IBMessages) getMessageType {
    return IBConnackMessage;
}

- (BOOL) isValidReturnCode : (IBConnectReturnCode) code {

    if (code >= IBAccepted && code <= IBNotAuthorized) {
        return true;
    }
    return false;
}

- (NSString *)description {
    
    NSString *code;
    
    switch (self->_returnCode) {
        case 0: code = @"MCAccepted"; break;
        case 1: code = @"MCUnacceptableProtocolVersion"; break;
        case 2: code = @"MCIdentifierRejected"; break;
        case 3: code = @"MCServerUnavaliable"; break;
        case 4: code = @"MCBadUserOrPass"; break;
        case 5: code = @"MCNotAuthorized"; break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"Session present value = %@, return code = %@", (self->_sessionPresentValue == true)?@"yes":@"no", code];
}

@end
