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

#import "IBPublish.h"
#import "IBMQTTEnums.h"

@implementation IBPublish

- (instancetype) initWithPacketID : (NSInteger) packetID andTopic : (IBMQTTTopic *) topic andContent : (NSData *) data andIsRetain : (BOOL) isRetain andDup : (BOOL) dup {

    self = [super init];
    if (self != nil) {
        self.packetID = packetID;
        self.topic = topic;
        self.content = data;
        self.isRetain = isRetain;
        self.dup = dup;
    }
    return self;
}

- (instancetype)initWithPacketID:(NSInteger)packetID {
    
    self = [super initWithPacketID:packetID];
    return self;
}

- (NSInteger) getMessageType {
    return IBPublishMessage;
}

- (NSInteger) getLength {

    NSInteger length = 0;
    length += (self.packetID != 0)? 2 : 0;
    length += [self.topic length] + 2;
    length += self.content.length;
    return length;
}

@end

// JSON Mapping

@interface IBPublish (JsonMapping)

@property (nonatomic) NSInteger messageType;
@property (nonatomic) NSString *jmContent;

@end

@implementation IBPublish (JsonMapping)

@dynamic messageType;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"messageType": @"packet",
                                                                  @"jmContent": @"content",
                                                                  @"isRetain": @"retain",
                                                                  }];
}

- (NSString *)jmContent {
    return [self->_content base64EncodedStringWithOptions:0];
}

- (void)setJmContent:(NSString *)jmContent {
    self->_content = [[NSData alloc] initWithBase64EncodedString:jmContent options:0];
}

@end
