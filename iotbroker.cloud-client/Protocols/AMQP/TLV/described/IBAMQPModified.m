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

#import "IBAMQPModified.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPModified

- (IBAMQPTLVList *)list {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_deliveryFailed != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapBOOL:self->_deliveryFailed]];
    }
    if (self->_undeliverableHere != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapBOOL:self->_undeliverableHere]];

    }
    if (self->_messageAnnotations != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapMap:self->_messageAnnotations]];
    }
    
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x27];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_deliveryFailed = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_undeliverableHere = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_messageAnnotations = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addMessageAnnotation : (NSString *) key value : (NSObject *) value {
    
    if (![key hasSuffix:@"x-"]) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (self->_messageAnnotations == nil) {
        self->_messageAnnotations = [NSMutableDictionary dictionary];
    }
    [self->_messageAnnotations setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
