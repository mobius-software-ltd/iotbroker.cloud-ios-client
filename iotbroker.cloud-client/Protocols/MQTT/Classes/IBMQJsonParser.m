/**
 * Mobius Software LTD
 * Copyright 2015-2018, Mobius Software LTD
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

#import "IBMQJsonParser.h"
#import "IBMQTTEnums.h"
#import "IBMQTTMessages.h"

@implementation IBMQJsonParser

+ (NSData *)json: (id<IBMessage>)message {
    
    IBMessages type = [message getMessageType];
    switch (type) {
        case IBConnectMessage: {
            IBConnect *connect = (IBConnect *)message;
            return [connect toJSONData];
        }
        case IBConnackMessage: {
            IBConnack *connack = (IBConnack *)message;
            return [connack toJSONData];
        }
        case IBPublishMessage: {
            IBPublish *publish = (IBPublish *)message;
            return [publish toJSONData];
        }
        case IBPubackMessage: {
            IBPuback *puback = (IBPuback *)message;
            return [puback toJSONData];
        }
        case IBPubrecMessage: {
            IBPubrec *pubrec = (IBPubrec *)message;
            return [pubrec toJSONData];
        }
        case IBPubrelMessage: {
            IBPubrel *pubrel = (IBPubrel *)message;
            return [pubrel toJSONData];
        }
        case IBPubcompMessage: {
            IBPubcomp *pubcomp = (IBPubcomp *)message;
            return [pubcomp toJSONData];
        }
        case IBSubscribeMessage: {
            IBSubscribe *subscribe = (IBSubscribe *)message;
            return [subscribe toJSONData];
        }
        case IBSubackMessage: {
            IBSuback *suback = (IBSuback *)message;
            return [suback toJSONData];
        }
        case IBUnsubscribeMessage: {
            IBUnsubscribe *unsubscribe = (IBUnsubscribe *)message;
            return [unsubscribe toJSONData];
        }
        case IBUnsubackMessage: {
            IBUnsuback *unsuback = (IBUnsuback *)message;
            return [unsuback toJSONData];
        }
        case IBPingreqMessage: {
            IBPingreq *pingreq = (IBPingreq *)message;
            return [pingreq toJSONData];
        }
        case IBPingrespMessage: {
            IBPingresp *pingresp = (IBPingresp *)message;
            return [pingresp toJSONData];
        }
        case IBDisconnectMessage: {
            IBDisconnect *disconnect = (IBDisconnect *)message;
            return [disconnect toJSONData];
        }
        default: {
            return [[NSData alloc] init];
        }
    }
}

+ (id<IBMessage>)message: (NSData *)json {
    
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
    
    if ([object objectForKey:@"packet"]) {
        IBMessages type = [[object objectForKey:@"packet"] integerValue];
        
        switch (type) {
            case IBConnectMessage: {
                return [[IBConnect alloc] initWithData:json error:nil];
            }
            case IBConnackMessage: {
                return [[IBConnack alloc] initWithData:json error:nil];
            }
            case IBPublishMessage: {
                return [[IBPublish alloc] initWithData:json error:nil];
            }
            case IBPubackMessage: {
                return [[IBPuback alloc] initWithData:json error:nil];
            }
            case IBPubrecMessage: {
                return [[IBPubrec alloc] initWithData:json error:nil];
            }
            case IBPubrelMessage: {
                return [[IBPubrel alloc] initWithData:json error:nil];
            }
            case IBPubcompMessage: {
                return [[IBPubcomp alloc] initWithData:json error:nil];
            }
            case IBSubscribeMessage: {
                return [[IBSubscribe alloc] initWithData:json error:nil];
            }
            case IBSubackMessage: {
                return [[IBSuback alloc] initWithData:json error:nil];
            }
            case IBUnsubscribeMessage: {
                return [[IBUnsubscribe alloc] initWithData:json error:nil];
            }
            case IBUnsubackMessage: {
                return [[IBUnsuback alloc] initWithData:json error:nil];
            }
            case IBPingreqMessage: {
                return [[IBPingreq alloc] initWithData:json error:nil];
            }
            case IBPingrespMessage: {
                return [[IBPingresp alloc] initWithData:json error:nil];
            }
            case IBDisconnectMessage: {
                return [[IBDisconnect alloc] initWithData:json error:nil];
            }
            default: {
                return nil;
            }
        }
    }
    return nil;
}

@end
