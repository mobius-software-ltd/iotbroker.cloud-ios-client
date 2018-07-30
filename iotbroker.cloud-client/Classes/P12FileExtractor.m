//
//  P12FileExtractor.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 30.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import "P12FileExtractor.h"
#include <openssl/pem.h>
#include <sys/stat.h>

char *buffer(X509 *cert) {
    BIO *bio_out = BIO_new(BIO_s_mem());
    PEM_write_bio_X509(bio_out, cert);
    BUF_MEM *bio_buf;
    BIO_get_mem_ptr(bio_out, &bio_buf);
    char *buffer = bio_buf->data;
    buffer[bio_buf->length] = '\0';
    return buffer;
}

bool isFileExist(char *fileName) {
    struct stat st;
    int result = stat(fileName, &st);
    return (result == 0);
}

@implementation P12FileExtractor

+ (char *)certificateFromP12:(NSString *)path passphrase:(NSString *)passphrase {
    if (!path) {
        return nil;
    }
    
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:path];
    if (!pkcs12data) {
        return nil;
    }
    
    if (!passphrase) {
        return nil;
    }
    CFArrayRef keyref = NULL;
    OSStatus importStatus = SecPKCS12Import((__bridge CFDataRef)pkcs12data,
                                            (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:passphrase forKey:(__bridge id)kSecImportExportPassphrase],
                                            &keyref);
    if (importStatus != noErr) {
        return nil;
    }
    
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(keyref, 0);
    NSLog(@"%@", identityDict);
    if (!identityDict) {
        return nil;
    }
    
    SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
    if (!identityRef) {
        return nil;
    };
    
    SecCertificateRef cert = NULL;
    OSStatus status = SecIdentityCopyCertificate(identityRef, &cert);
    if (status != noErr) {
        return nil;
    }
    
    NSData *certificateData = (NSData *) CFBridgingRelease(SecCertificateCopyData(cert));
    const unsigned char *certificateDataBytes = (const unsigned char *)[certificateData bytes];
    
    X509 *certificateX509 = d2i_X509(NULL, &certificateDataBytes, [certificateData length]);
    
    return buffer(certificateX509);
}

@end
