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
