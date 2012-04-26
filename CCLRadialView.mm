#import "CCLRadialView.h"
#import "CCLMath.h"

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
- (void)awakeFromNib {
    [self cycle];
}

- (void)drawRect:(NSRect)rect {
    
    rect = [self bounds];

//    Re saturation = [color saturationComponent];
//    Re lightness = [color brightnessComponent];
    
    Re width = 2.0 * rect.size.width;
    Re height = 2.0 * rect.size.height;
    
#if 0
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
#endif
    
    uint32_t* data = new uint32_t[int(width * height)] ();
    
    for (Re j = 0; j < height; j++) {
        for (Re i = 0; i < width; i++) {
                        
            Re x = i / width;
            Re y = j / height;
            
            x = x * 2.0 - 1.0;
            y = y * 2.0 - 1.0;
            
            Re d = sqrt(x * x + y * y);
            if (d >= 1.0 || d <= -1.0)
                continue;
            
            Cmplx z = cirtosq(Cmplx(x, y));
            
            Re sat = (imag(z) + 1.0) / 2.0;
            Re light = (real(z) + 1.0) / 2.0;
            
            Vec3 lch = Vec3(light * 100.0, sat * 100.0, h);
            Vec3 lab = lch_to_lab(lch);
            Vec3 xyz = lab_to_xyz(lab);
            Vec3 lrgb = xyz_to_rgb(xyz);
            Vec3 rgb = lrgb_to_srgb(lrgb);
            
//            NSColor *rgbcolor = [[NSColor colorWithSRGBRed:rgb.x green:rgb.y blue:rgb.z alpha:1.0f] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//            CGFloat r,g,b,a;
//            [rgbcolor getRed:&r green:&g blue:&b alpha:&a];
            CGFloat r = clip01(rgb.x), g = clip01(rgb.y), b = clip01(rgb.z);
            
            data[(int)(i + (j * width))] = (((int)(r * 255)) << 24) | (((int)(g * 255)) << 16) | (((int)(b * 255)) << 8) | 0xFF;            
        }
    }
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:(unsigned char**)&data
                                                                    pixelsWide:width
                                                                    pixelsHigh:height
                                                                 bitsPerSample:8
                                                               samplesPerPixel:4
                                                                      hasAlpha:YES
                                                                      isPlanar:NO
                                                                colorSpaceName:NSCalibratedRGBColorSpace
                                                                  bitmapFormat:NSAlphaFirstBitmapFormat
                                                                   bytesPerRow:width * 4
                                                                  bitsPerPixel:32];
    
    [rep bitmapImageRepByRetaggingWithColorSpace:[NSColorSpace sRGBColorSpace]];
    [rep drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:NO hints:nil];
    delete[] data;
}
- (void)cycle {
    h += fmod(M_PI_4 / 16.0, M_2_PI);
    [self setNeedsDisplay:YES];
    [self performSelector:@selector(cycle) withObject:nil afterDelay:0.1];
}
@end
