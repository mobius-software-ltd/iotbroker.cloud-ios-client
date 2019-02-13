//
//  Message+CoreDataProperties.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Message"];
}

@dynamic content;
@dynamic isDup;
@dynamic isIncoming;
@dynamic isRetain;
@dynamic qos;
@dynamic topicName;
@dynamic date;
@dynamic account;

- (BOOL) isValid {
    if (self.content.length == 0 || self.topicName.length == 0) {
        return false;
    }
    return true;
}

@end
