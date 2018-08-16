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

#import "IBDtls.h"

#define MAXBUF 1024

static int min (int a, int b)
{
    return a > b ? b : a;
}

int dtls_sendto_cb(WOLFSSL* ssl, char* buf, int sz, void* ctx)
{
    SharedDtls* shared = (SharedDtls*)ctx;
    return (int)sendto(shared->sd, buf, sz, (ssize_t)0, (const struct sockaddr*)&shared->servAddr, shared->servSz);
}

int dtls_recvfrom_cb(WOLFSSL* ssl, char* buf, int sz, void* ctx)
{
    SharedDtls* shared = (SharedDtls*)ctx;
    int copied;
    
    if (!shared->handShakeDone) {
        /* get directly from socket */
        return (int)recvfrom(shared->sd, buf, sz, 0, NULL, NULL);
    } else {
        /* get the "pushed" datagram from our cb buffer instead */
        copied = min(sz, shared->recvSz);
        NSLog(@"%s , %s", buf, shared->recvBuf);
        memcpy(buf, shared->recvBuf, copied);
        shared->recvSz -= copied;
        return copied;
    }
}

///* DTLS Send function in its own thread */
void* datagramSend(void* arg)
{
    SharedDtls* shared = (SharedDtls*)arg;
    WOLFSSL*    ssl = shared->ssl;
    
    wc_LockMutex(&shared->shared_mutex);
    if ((wolfSSL_write(ssl, shared->sndBuf, shared->sndSz)) != shared->sndSz) {
        IBDtls *dtls = (__bridge IBDtls *)shared->dtlsInst;
        [dtls.delegate error:(char *)"Error while send the message."];
    }
    wc_UnLockMutex(&shared->shared_mutex);
    return NULL;
}

@implementation IBDtls

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->isRun = true;
        self->tindex = 0;
        self->tid = (pthread_t *)malloc(sizeof(pthread_t));
    }
    return self;
}

- (void) setHost: (char *)host andPort: (int)port {
    self->host = host;
    self->port = port;
}

- (void) setCaCertificate: (char *)caCert andCertificate: (char *)cert {
    self->caCertificate = caCert;
    self->certificate = cert;
}

- (void) start {
    int          sockfd = 0;
    WOLFSSL*      ssl = 0;
    WOLFSSL_CTX* ctx = 0;
    
    int          sz = 0;
    char         recvBuf[MAXBUF];
    char         plainBuf[MAXBUF];
    
    recvShared = &shared;
    
    wolfSSL_Init();
    
    if ((ctx = wolfSSL_CTX_new(wolfDTLSv1_2_client_method())) == NULL) {
        [self.delegate error:(char *)"Dtls initialize error."];
        return;
    }
    
    if (wolfSSL_CTX_load_verify_buffer(ctx, (const unsigned char *)self->caCertificate, strlen(self->caCertificate), SSL_FILETYPE_PEM) != SSL_SUCCESS) {
        char message[64];
        sprintf(message, "Error while loading CA Certificete file");
        [self.delegate error:message];
        return;
    }
    
    wolfSSL_SetIOSend(ctx, dtls_sendto_cb);
    wolfSSL_SetIORecv(ctx, dtls_recvfrom_cb);
    
    NSLog(@"-> %s", self->caCertificate);
    
    ssl = wolfSSL_new(ctx);
    if (ssl == NULL) {
        [self.delegate error:(char *)"SSL initialize error."];
        return;
    }
    
    memset(&shared.servAddr, 0, sizeof(shared.servAddr));
    shared.servAddr.sin_family = AF_INET;
    shared.servAddr.sin_port = htons(self->port);
    if (inet_pton(AF_INET, self->host, &shared.servAddr.sin_addr) < 1) {
        [self.delegate error:(char *)"Error and/or invalid IP address."];
        return;
    }
    
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        [self.delegate error:(char *)"Cannot create a socket."];
        return;
    }
    
    shared.sd = sockfd;
    shared.servSz = sizeof(shared.servAddr);
    shared.ssl = ssl;
    shared.handShakeDone = 0;
    
    if (wc_InitMutex(&shared.shared_mutex) != 0) {
        [self.delegate error:(char *)"Mutex initialize error."];
        return;
    }
    
    wolfSSL_SetIOWriteCtx(ssl, &shared);
    wolfSSL_SetIOReadCtx(ssl, &shared);
    
    if (wolfSSL_connect(ssl) != SSL_SUCCESS) {
        [self.delegate error:(char *)"SSL connect error."];
        return;
    }
    
    [self.delegate didConnect];
    
    shared.handShakeDone = 1;
    
    /* DTLS Recv */
    while(self->isRun) {
        /* first get datagram, works in blocking mode too */
        sz = (int)recvfrom(recvShared->sd, recvBuf, MAXBUF, 0, NULL, NULL);
        
        wc_LockMutex(&recvShared->shared_mutex);
        recvShared->recvBuf = recvBuf;
        recvShared->recvSz = sz;
        
        if (self->isRun) {
            if ( (sz = (wolfSSL_read(ssl, plainBuf, MAXBUF-1))) < 0) {
                [self.delegate error:(char *)"Error while read the message."];
            }
        }
        wc_UnLockMutex(&recvShared->shared_mutex);
        plainBuf[MAXBUF-1] = '\0';
        
        [self.delegate received:plainBuf];
    }
    
    for (int i = 0; i < self->tindex + 1; i++) {
        pthread_join(self->tid[i], NULL);
    }
    
    [self.delegate didDisconnect];
    
    wolfSSL_shutdown(ssl);
    wolfSSL_free(ssl);
    close(sockfd);
    wolfSSL_CTX_free(ctx);
    wc_FreeMutex(&shared.shared_mutex);
    wolfSSL_Cleanup();
}

- (void) send: (char *)message {
    pthread_t tid;
    
    shared.sndBuf = message;
    shared.sndSz = (int)strlen(shared.sndBuf) + 1;
    
    pthread_create(&tid, NULL, datagramSend, &shared);
    self->tid[self->tindex] = tid;
    
    self->tindex++;
    self->tid = (pthread_t *)realloc(self->tid, (self->tindex + 1) * sizeof(pthread_t));
}

- (void) stop {
    self->isRun = false;
    close(self->recvShared->sd);
}

@end
