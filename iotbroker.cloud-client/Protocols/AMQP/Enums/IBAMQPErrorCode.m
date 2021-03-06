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

#import "IBAMQPErrorCode.h"

@implementation IBAMQPErrorCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPInternalErrorCode)              forKey:@"amqp:internal-error"];
        [self->_dictionary setValue:@(IBAMQPNotFoundErrorCode)              forKey:@"amqp:not-found"];
        [self->_dictionary setValue:@(IBAMQPUnauthorizedAccessErrorCode)    forKey:@"amqp:unauthorized-access"];
        [self->_dictionary setValue:@(IBAMQPDecodeErrorCode)                forKey:@"amqp:decode-error"];
        [self->_dictionary setValue:@(IBAMQPResourceLimitExceededErrorCode) forKey:@"amqp:resource-limit-exceeded"];
        [self->_dictionary setValue:@(IBAMQPNotAllowedErrorCode)            forKey:@"amqp:not-allowed"];
        [self->_dictionary setValue:@(IBAMQPInvalidFieldErrorCode)          forKey:@"amqp:invalid-field"];
        [self->_dictionary setValue:@(IBAMQPNotImplementedErrorCode)        forKey:@"amqp:not-implemented"];
        [self->_dictionary setValue:@(IBAMQPResourceLockedErrorCode)        forKey:@"amqp:resource-locked"];
        [self->_dictionary setValue:@(IBAMQPPreconditionFailedErrorCode)    forKey:@"amqp:precondition-failed"];
        [self->_dictionary setValue:@(IBAMQPResourceDeletedErrorCode)       forKey:@"amqp:resource-deleted"];
        [self->_dictionary setValue:@(IBAMQPIllegalStateErrorCode)          forKey:@"amqp:illegal-state"];
        [self->_dictionary setValue:@(IBAMQPFrameSizeTooSmallErrorCode)     forKey:@"amqp:frame-size-too-small"];
        [self->_dictionary setValue:@(IBAMQPConnectionForcedErrorCode)      forKey:@"amqp:connection-forced"];
        [self->_dictionary setValue:@(IBAMQPFramingErrorCode)               forKey:@"amqp:framing-error"];
        [self->_dictionary setValue:@(IBAMQPRedirectedErrorCode)            forKey:@"amqp:redirected"];
        [self->_dictionary setValue:@(IBAMQPWindowViolationErrorCode)       forKey:@"amqp:window-violation"];
        [self->_dictionary setValue:@(IBAMQPErrantLinkErrorCode)            forKey:@"amqp:errant-link"];
        [self->_dictionary setValue:@(IBAMQPHandleInUseErrorCode)           forKey:@"amqp:handle-in-use"];
        [self->_dictionary setValue:@(IBAMQPUnattachedHandleErrorCode)      forKey:@"amqp:unattached-handle"];
        [self->_dictionary setValue:@(IBAMQPDetachForcedErrorCode)          forKey:@"amqp:detach-forced"];
        [self->_dictionary setValue:@(IBAMQPTransferLimitExceededErrorCode) forKey:@"amqp:transfer-limit-exceeded"];
        [self->_dictionary setValue:@(IBAMQPMessageSizeExceededErrorCode)   forKey:@"amqp:message-size-exceeded"];
        [self->_dictionary setValue:@(IBAMQPRedirectErrorCode)              forKey:@"amqp:redirect"];
        [self->_dictionary setValue:@(IBAMQPStolenErrorCode)                forKey:@"amqp:stolen"];
    }
    return self;
}

- (instancetype) initWithErrorCode : (IBAMQPErrorCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithErrorCode : (IBAMQPErrorCodes) type {
    return [[IBAMQPErrorCode alloc] initWithErrorCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number integerValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPErrorCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
