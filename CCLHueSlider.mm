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
    
    
    Re width = 2.0 * rect.size.width;
    Re height = 2.0 * rect.size.height;
    
    Re inner = width - [[[self subviews] lastObject] bounds].size.width;
    inner /= 2.0;
    
    uint32_t *data = new uint32_t[(int)(width * height)] ();
    
    for (Re i = 0; i < width; i++) {
        for (Re j = 0; j < height; j++) {
            
            Re x = i / width;
            Re y = j / height;
            
            x = x * 2.0 - 1.0;
            y = y * 2.0 - 1.0;
            
            Re d = sqrt(x * x + y * y);
            if (d >= 1.0 || d <= -1.0)
                continue;
            
            if (d <= 1.0 - 2.5 * inner / width && d >= -1.0 + 2.5 * inner / width)
                continue;
            
            Cmplx z = Cmplx(x, y);
            
            Vec3 lch = Vec3(80.0, 100.0, arg(Cmplx(x, y)));
            Vec3 lab = lch_to_lab(lch);
            Vec3 xyz = lab_to_xyz(lab);
            Vec3 lrgb = xyz_to_rgb(xyz);
            Vec3 rgb = lrgb_to_srgb(lrgb);
            
            NSColor *rgbcolor = [[NSColor colorWithSRGBRed:rgb.x green:rgb.y blue:rgb.z alpha:1.0f] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
            CGFloat r,g,b,a;
            [rgbcolor getRed:&r green:&g blue:&b alpha:&a];
            
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
    
    [rep drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:NO hints:nil];
    delete[] data;
}

@end
