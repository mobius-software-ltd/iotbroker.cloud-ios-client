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

#import "IBDashBorderButton.h"

@implementation IBDashBorderButton

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    
    UIColor* fillColor = [UIColor clearColor];
    UIColor* strokeColor = [UIColor colorWithRed:150.0/255.0 green:158.0/255.0  blue:163.0/255.0  alpha:1.0];
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius: 16];
    [fillColor setFill];
    [rectanglePath fill];
    [strokeColor setStroke];
    rectanglePath.lineWidth = 3;
    CGFloat rectanglePattern[] = {6, 3, 6, 3};
    [rectanglePath setLineDash: rectanglePattern count:1 phase:0];
    [rectanglePath stroke];
}

@end
