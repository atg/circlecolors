//
//  CCLHueSlider.m
//  circlecolors
//
//  Created by Alex Gordon on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLHueSlider.h"
#import "CCLMath.h"

@implementation CCLHueSlider

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    rect = [self bounds];

//    Re saturation = [color saturationComponent];
//    Re lightness = [color brightnessComponent];
    
    if (![[self subviews] lastObject])
        return;
    
    
    Re width = rect.size.width;
    Re height = rect.size.height;
    
    Re inner = width - [[[self subviews] lastObject] bounds].size.width;
    inner /= 2.0;
    
    vector<NSRect> rects;
    vector<NSColor*> colors;
    
//    [[NSColor greenColor] set];
//    NSRectFillUsingOperation(rect, NSCompositeSourceOver);
    
    for (Re i = 0; i < width; i++) {
        for (Re j = 0; j < height; j++) {
            
            Re x = i / width;
            Re y = j / height;
            
            x = x * 2.0 - 1.0;
            y = y * 2.0 - 1.0;
            
            Re d = sqrt(x * x + y * y);
            if (d >= 1.0 || d <= -1.0)
                continue;
            
            if (d <= 1.0 - 2.0 * inner / width && d >= -1.0 + 2.0 * inner / width)
                continue;
            
            //            if (d < 0.99 && d > -0.99)
            //                continue;
            
            //            printcmplx(Cmplx(x, y));
            
            Cmplx z = Cmplx(x, y);
            
            //            printcmplx(Cmplx(real(z), imag(z)));
            //            z = (z + Complex) / 2.0;
            
//            Re sat = (imag(z) + 1.0) / 2.0;
//            Re light = (real(z) + 1.0) / 2.0;
            
            
            //            printcmplx(Cmplx(light, sat));
            //            printf("---\n");
            
            // lch_to_lab
            Vec3 lch = Vec3(80.0, 100.0, arg(Cmplx(x, y)));
            Vec3 lab = lch_to_lab(lch);
            Vec3 xyz = lab_to_xyz(lab);
            Vec3 lrgb = xyz_to_rgb(xyz);
            Vec3 rgb = lrgb_to_srgb(lrgb);
            NSColor* dotcolor = [NSColor colorWithSRGBRed:rgb.x green:rgb.y blue:rgb.z alpha:1.0];
            //            NSColor* dotcolor = [NSColor colorWithCalibratedRed:rgb.x green:rgb.y blue:rgb.z alpha:1.0];
            //            NSColor* dotcolor = [NSColor colorWithCalibratedHue:0.0 saturation:sat brightness:light alpha:1.0];
            
            rects.push_back(NSMakeRect(i, j, 1.0, 1.0));
            colors.push_back(dotcolor);
            
        }
    }
    
    NSRectFillListWithColorsUsingOperation(&rects[0], &colors[0], rects.size(), NSCompositeSourceOver);
}

@end
