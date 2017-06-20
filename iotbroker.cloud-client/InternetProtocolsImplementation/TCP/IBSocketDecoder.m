/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
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

#import "IBSocketDecoder.h"

@implementation IBSocketDecoder

- (instancetype)init {
    self = [super init];
    self.state = IBSocketDecoderInitialState;
    
    self.stream = nil;
    self.runLoop = [NSRunLoop currentRunLoop];
    self.runLoopMode = NSRunLoopCommonModes;
    return self;
}

- (void)start {
    if (self.state == IBSocketDecoderInitialState) {
        [self.stream setDelegate:self];
        [self.stream scheduleInRunLoop:self.runLoop forMode:self.runLoopMode];
        [self.stream open];
    }
}

- (void)stop {
    [self.stream close];
    [self.stream removeFromRunLoop:self.runLoop forMode:self.runLoopMode];
    [self.stream setDelegate:nil];
}

- (void)stream:(NSStream *)sender handleEvent:(NSStreamEvent)eventCode {
    
    if (eventCode & NSStreamEventOpenCompleted) {
        self.state = IBSocketDecoderReadyState;
        [self.delegate decoderDidOpen:self];
    }
    
    if (eventCode &  NSStreamEventHasBytesAvailable) {
        if (self.state == IBSocketDecoderInitialState) {
            self.state = IBSocketDecoderReadyState;
        }
        
        if (self.state == IBSocketDecoderReadyState) {
            NSInteger number;
            UInt8 buffer[2048];
            
            number = [self.stream read:buffer maxLength:sizeof(buffer)];
            if (number == -1) {
                self.state = IBSocketDecoderErrorState;
                [self.delegate decoder:self didFailWithError:nil];
            } else {
                NSData *data = [NSData dataWithBytes:buffer length:number];
                [self.delegate decoder:self didReceiveMessage:data];
            }
        }
    }
    
    if (eventCode &  NSStreamEventEndEncountered) {
        self.state = IBSocketDecoderInitialState;
        self.error = nil;
        [self.delegate decoderdidClose:self];
    }
    
    if (eventCode &  NSStreamEventErrorOccurred) {
        self.state = IBSocketDecoderErrorState;
        self.error = self.stream.streamError;
        [self.delegate decoder:self didFailWithError:self.error];
    }
}

- (void)dealloc {
    [self stop];
}

@end
