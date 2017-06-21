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

#import "IBAMQPLifetimePolicyObject.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPLifetimePolicyObject

- (instancetype) initWithCode : (IBAMQPLifetimePolicies) code {
    self = [super init];
    if (self != nil) {
        self->_code = code;
    }
    return self;
}

- (IBAMQPTLVList *)list {
    
    
    IBAMQPTLVList *tlvList = [[IBAMQPTLVList alloc] init];
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:(Byte)self.code];
    
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:[[IBAMQPType alloc] initWithType:tlvList.type]
                                                                                 andDescriptor:[[IBAMQPTLVFixed alloc] initWithType:type andValue:data]];
    tlvList.constructor = constructor;
    return tlvList;
}

- (void)fill:(IBAMQPTLVList *)list {
    
    if (!list.isNull) {
        IBAMQPDescribedConstructor *constructor = (IBAMQPDescribedConstructor *)list.constructor;
        self.code = (constructor.descriptorCode & 0xff);
    }
}

@end
