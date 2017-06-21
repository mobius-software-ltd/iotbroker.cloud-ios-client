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

#import "IBAMQPHeader.h"

@implementation IBAMQPHeader

- (instancetype) initWithCode : (IBAMQPHeaderCode *) code {
    self = [super init];
    if (self != nil) {
        self->_code = code;
        self->_doff = 2;
        self->_type = 0;
        self->_chanel = 0;
    }
    return self;
}

- (NSInteger)getLength {
    return 8;
}

- (NSInteger)getMessageType {
    return 0;
}

- (IBAMQPTLVList *) arguments {
    @throw [NSException exceptionWithName:[[self class] description] reason:@"arguments: - abstract" userInfo:nil];
    return nil;
}

- (void) fillArguments : (IBAMQPTLVList *) list {
    @throw [NSException exceptionWithName:[[self class] description] reason:@"fillArguments: - abstract" userInfo:nil];
}

@end
