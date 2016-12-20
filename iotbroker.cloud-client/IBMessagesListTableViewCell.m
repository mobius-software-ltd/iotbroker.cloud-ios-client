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

#import "IBMessagesListTableViewCell.h"

@implementation IBMessagesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *qosMaskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.qosBackgroundView.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(self.qosBackgroundView.frame.size.height / 2, self.qosBackgroundView.frame.size.height / 2)
                              ];
    
    CAShapeLayer *qosMaskLayer = [CAShapeLayer layer];
    
    qosMaskLayer.frame = self.bounds;
    qosMaskLayer.path = qosMaskPath.CGPath;
    
    self.qosBackgroundView.layer.mask = qosMaskLayer;
    
    UIBezierPath *typeMaskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.messageTypeBackgroundView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(self.messageTypeBackgroundView.frame.size.height / 2, self.messageTypeBackgroundView.frame.size.height / 2)
                              ];
    
    CAShapeLayer *typeMaskLayer = [CAShapeLayer layer];
    
    typeMaskLayer.frame = self.bounds;
    typeMaskLayer.path = typeMaskPath.CGPath;
    
    self.messageTypeBackgroundView.layer.mask = typeMaskLayer;
}

- (void) setMessageType : (IBMessageType) type {
    
    if (type == IBIncomingMessage) {
        self.messageTypeLabel.text = @"in";
    } else if (type == IBOutgoingMessage) {
        self.messageTypeLabel.text = @"out";
    }
}

@end
