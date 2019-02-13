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

#import "IBWill.h"

@implementation IBWill

- (instancetype) initWithTopic : (IBMQTTTopic *) topic content : (NSData *) content andIsRetain : (BOOL) retain {

    self = [super init];
    if (self != nil) {
        self.topic = topic;
        self.content = content;
        self.isRetain = retain;
    }
    return self;
}

- (NSInteger) retrieveLength {
    return self.topic.length + self.content.length + 4;
}

- (BOOL) isValid {
    return (self.topic != nil) && (self.topic.length > 0) && (self.content != nil) && (self.topic.qos != nil);
}

@end

// JSON Mapping

@interface IBWill (JsonMapping)

@property (nonatomic) NSString *jmContent;

@end

@implementation IBWill (JsonMapping)

@dynamic jmContent;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"jmContent": @"content",
                                                                  @"isRetain": @"retain"
                                                                  }];
}

- (NSString *)jmContent {
    return [self->_content base64EncodedStringWithOptions:0];
}

- (void)setJmContent:(NSString *)jmContent {
    self->_content = [[NSData alloc] initWithBase64EncodedString:jmContent options:0];
}

@end
