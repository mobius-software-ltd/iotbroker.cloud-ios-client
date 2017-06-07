//
//  IBAMQPSymbol.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAMQPSymbol : NSObject

@property (strong, nonatomic) NSString *value;

- (instancetype) initWithString : (NSString *) value;

@end
