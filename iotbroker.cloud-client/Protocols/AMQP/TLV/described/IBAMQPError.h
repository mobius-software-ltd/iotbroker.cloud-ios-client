//
//  IBAMQPError.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPErrorCode.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPTLVList.h"

@interface IBAMQPError : NSObject

@property (strong, nonatomic) IBAMQPErrorCode *condition;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic, readonly) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *info;

- (IBAMQPTLVList *) list;
- (void) fill : (IBAMQPTLVList *) list;
- (void) addInfo : (NSString *) key value : (NSObject *) value;

@end
