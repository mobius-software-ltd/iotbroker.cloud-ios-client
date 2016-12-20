/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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

#import "IBSocketEncoder.h"

@interface IBSocketEncoder()
@property (strong, nonatomic) NSMutableData *buffer;
@end

@implementation IBSocketEncoder

- (instancetype)init {
    self = [super init];
    self.state = IBSocketEncoderInitialState;
    self.buffer = [[NSMutableData alloc] init];
    
    self.stream = nil;
    self.runLoop = [NSRunLoop currentRunLoop];
    self.runLoopMode = NSRunLoopCommonModes;
    
    return self;
}

- (void)start {
    [self.stream setDelegate:self];
    [self.stream scheduleInRunLoop:self.runLoop forMode:self.runLoopMode];
    [self.stream open];
}

- (void)stop {
    [self.stream close];
    [self.stream removeFromRunLoop:self.runLoop forMode:self.runLoopMode];
    [self.stream setDelegate:nil];
}

- (void)setState:(IBSocketEncoderState)state {
    self->_state = state;
}

- (void)stream:(NSStream *)sender handleEvent:(NSStreamEvent)eventCode {
    
    if (eventCode & NSStreamEventHasSpaceAvailable) {
        if (self.state == IBSocketEncoderInitialState) {
            self.state = IBSocketEncoderReadyState;
            [self.delegate encoderDidOpen:self];
        }
        
        if (self.state == IBSocketEncoderReadyState) {
            if (self.buffer.length) {
                [self write:nil];
            }
        }
    }
    
    if (eventCode &  NSStreamEventEndEncountered) {
        self.state = IBSocketEncoderInitialState;
        self.error = nil;
        [self.delegate encoderdidClose:self];
    }
    
    if (eventCode &  NSStreamEventErrorOccurred) {
        self.state = IBSocketEncoderErrorState;
        self.error = self.stream.streamError;
        [self.delegate encoder:self didFailWithError:self.error];
    }
}

- (BOOL)write : (NSData *) data {
    @synchronized(self) {
        if (self.state != IBSocketEncoderReadyState) {
            return false;
        }
        
        if (data) {
            [self.buffer appendData:data];
        }
        
        if (self.buffer.length) {
            
            NSInteger n = [self.stream write:self.buffer.bytes maxLength:self.buffer.length];
            
            if (n == -1) {
                self.state = IBSocketEncoderErrorState;
                self.error = self.stream.streamError;
                return false;
            } else {
                [self.buffer replaceBytesInRange:NSMakeRange(0, n) withBytes:NULL length:0];
            }
        }
        return true;
    }
}

- (void)dealloc {
    [self stop];
}


@end
