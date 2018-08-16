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
