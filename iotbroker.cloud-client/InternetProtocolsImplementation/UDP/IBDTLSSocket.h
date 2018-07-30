//
//  DTLSSocket.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 30.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBInternetProtocol.h"
#import "IBDtls.h"

@interface IBDTLSSocket : NSObject <IBInternetProtocol>

@property (strong, nonatomic, readonly) IBDtls *dtlsSocket;

- (void) setCertificate: (char *)certificate;

@end
