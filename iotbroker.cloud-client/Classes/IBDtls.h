//
//  Dtls.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 30.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <wolfssl/ssl.h>
#include <wolfssl/wolfcrypt/wc_port.h>
#include <unistd.h>
#include <netdb.h>
#include <signal.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

@class IBDtls;

@protocol IBDtlsDelegate

- (void) didConnect;
- (void) didDisconnect;
- (void) received: (char *)message;
- (void) error: (char *)message;

@end

typedef struct SharedDtls {
    wolfSSL_Mutex      shared_mutex;  /* mutex for using */
    WOLFSSL*           ssl;           /* WOLFSSL object being shared */
    int                sd;            /* socket fd */
    struct sockaddr_in servAddr;      /* server sockaddr */
    socklen_t          servSz;        /* length of servAddr */
    char*              recvBuf;       /* I/O recv cb buffer */
    int                recvSz;          /* bytes in recvBuf */
    int                handShakeDone;   /* is the handshake done? */
    char*              sndBuf;
    int                sndSz;
    void*              dtlsInst;
} SharedDtls;

@interface IBDtls : NSObject
{
    char *host;
    int port;
    
    char *certificate;
    char *caCertificate;
    
    SharedDtls shared;
    SharedDtls* recvShared;
    
    int tindex;
    pthread_t *tid;
    
    bool isRun;
}

@property (weak, nonatomic) id<IBDtlsDelegate> delegate;

- (void) setHost: (char *)host andPort: (int)port;
- (void) setCaCertificate: (char *)caCert andCertificate: (char *)cert;

- (void) start;
- (void) send: (char *)message;
- (void) stop;

@end
