//
//  P12FileExtractor.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 30.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P12FileExtractor : NSObject

+ (char *)certificateFromP12:(NSString *)path passphrase:(NSString *)passphrase;

@end
