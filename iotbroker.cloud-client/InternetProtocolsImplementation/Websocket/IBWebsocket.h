//
//  IBWebsocket.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.08.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SocketRocket.h>
#import "IBInternetProtocol.h"

@interface IBWebsocket : NSObject <IBInternetProtocol>

@property (strong, nonatomic, readonly) SRWebSocket *webSocket;

- (void) setCertificate: (char *)certificate;

@end
