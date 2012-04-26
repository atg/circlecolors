//
//  CCLRadialView.m
//  circlecolors
//
//  Created by Alex Gordon on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLRadialView.h"
#import "CCLMath.h"

const Re SATURATION_RESOLUTION = 100;
const Re LIGHTNESS_RESOLUTION = 100;

@implementation CCLRadialView

@synthesize color;

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
//    printf("fpropermod(-1.0/2.0, 2.0) = %lf\n", fpropermod(-1.0/2.0, 2.0));
//    return;
    Re saturation = [color saturationComponent];
    Re lightness = [color brightnessComponent];
    
    Re width = rect.size.width;
    Re height = rect.size.height;
    
    printcmplx(sqtocir(Cmplx(-1, -1)));
    printcmplx(sqtocir(Cmplx(-1, 1)));
    printcmplx(sqtocir(Cmplx(-1, 0)));
    printcmplx(sqtocir(Cmplx(1, -1)));
    printcmplx(sqtocir(Cmplx(1, 1)));
    printcmplx(sqtocir(Cmplx(1, 0)));
    printcmplx(sqtocir(Cmplx(0, -1)));
    printcmplx(sqtocir(Cmplx(0, 1)));
    printcmplx(sqtocir(Cmplx(0, 0)));
    printcmplx(sqtocir(Cmplx(0.5, 0)));
    printcmplx(sqtocir(Cmplx(0.5, 0.5)));
    printcmplx(cirtosq(Cmplx(-0.992188, -0.007812)));

//    return;
    
    vector<NSRect> rects;
    vector<NSColor*> colors;
    
//    [[NSColor magentaColor] set];
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
//            if (d < 0.99 && d > -0.99)
//                continue;
            
//            printcmplx(Cmplx(x, y));
            
            Cmplx z = cirtosq(Cmplx(x, y));
            
//            printcmplx(Cmplx(real(z), imag(z)));
//            z = (z + Complex) / 2.0;
            
            Re sat = (imag(z) + 1.0) / 2.0;
            Re light = (real(z) + 1.0) / 2.0;
            
            
//            printcmplx(Cmplx(light, sat));
//            printf("---\n");
            
            // lch_to_lab
            Vec3 lch = Vec3(light * 100.0, sat * 100.0, -M_PI_2);
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
    NSLog(@"rects = %ld", rects.size());
    NSRectFillListWithColorsUsingOperation(&rects[0], &colors[0], rects.size(), NSCompositeSourceOver);
    /*
//    Cmplx z = Cmplx(lightness, saturation);
    
    for (CGFloat s = 0.0; s <= 1.0; s += 1.0 / SATURATION_RESOLUTION) {
        for (CGFloat l = 0.0; l <= 1.0; l += 1.0 / LIGHTNESS_RESOLUTION) {
            
            if (sqrt(s * s + l * l) > 1.0)
                continue;
            
            Cmplx cz = cirtosq(Cmplx(s, l);
            
            
            NSColor* c = [NSColor colorWithCalibratedHue:0.0 saturation:s brightness:l alpha:1.0];
            
        }
    }*/
    
}

@end
