//
//  CCLRadialView.h
//  circlecolors
//
//  Created by Alex Gordon on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCLRadialView : NSView {
    NSColor* color;
    CGFloat h;
}

@property (strong) NSColor* color;

- (void)cycle;

@end
