#import <complex>
#import <cmath>
#import <vector>
using namespace std;

// TODO: Replace these with the proper white point values
const double Xn = 1.0;
const double Yn = 1.0;
const double Zn = 1.0;


typedef double Re;
typedef complex<Re> Cmplx;

struct Vec3 {
    Re x;
    Re y;
    Re z;
    
    Vec3() : x(0), y(0), z(0) { }
    Vec3(Re x_, Re y_, Re z_) : x(x_), y(y_), z(z_) { }
    
    
};

static Vec3 operator + (Vec3 u, Vec3 v) {
    return Vec3(u.x + v.x, u.y + v.y, u.z + v.z);
}
static Vec3 operator * (Re u, Vec3 v) {
    return Vec3(u * v.x, u * v.y, u * v.z);
}
static Vec3 operator - (Vec3 u, Vec3 v) {
    return Vec3(u.x - v.x, u.y - v.y, u.z - v.z);
}
static Vec3 operator - (Vec3 v) {
    return Vec3(- v.x, - v.y, - v.z);
}

static Re clip01(Re x) {
    if (x < 0.0)
        return 0.0;
    if (x > 1.0)
        return 1.0;
    return x;
}


static double fpropermod(Re a, Re n) {
    return a - n * floor(a / n);
}

static Vec3 xyz_to_rgb(Vec3 xyz) {
    Re x = xyz.x;
    Re y = xyz.y;
    Re z = xyz.z;
    
    return Vec3(3.2406*x - 1.5372*y - 0.4986*z,
                -0.9689*x + 1.8758*y + 0.0415*z,
                0.0557*x - 0.204*y + 1.057*z);
}
static Vec3 rgb_to_xyz(Vec3 rgb) {
    Re r = rgb.x;
    Re g = rgb.y;
    Re b = rgb.z;
    
    return Vec3(0.180493*b + 0.357583*g + 0.412396*r,
                0.0722005*b + 0.71517*g + 0.212586*r,
                0.950497*b + 0.119184*g + 0.0192972*r);
}



static Re xyz_to_lab_f(Re t) {
    //    if (t > pow(6.0/29.0, 3.0))    ORIGINAL BUT I THINK THIS IS AN ERROR ON WIKIPEDIA
    if (t > 6.0 / 29.0)
        return pow(t, 1.0/3.0);
    return (1.0/3.0) * pow(29.0 / 6.0, 2.0) * t + 4.0/29.0;
}
static Vec3 xyz_to_lab(Vec3 xyz) {
    Re x = xyz.x;
    Re y = xyz.y;
    Re z = xyz.z;
    
    Re l = 116.0 * xyz_to_lab_f(y / Yn) - 16.0;
    Re a = 500.0 * (xyz_to_lab_f(x / Xn) - xyz_to_lab_f(y / Yn));
    Re b = 200.0 * (xyz_to_lab_f(y / Yn) - xyz_to_lab_f(z / Zn));
    
    return Vec3(l, a, b);
}

static Re lab_to_xyz_f(Re t) {
    if (t > 6.0 / 29.0)
        return pow(t, 3.0);
    return 3.0 * pow(6.0 / 29.0, 2.0) * (t - 4.0/29.0);
}
static Vec3 lab_to_xyz(Vec3 lab) {
    Re l = lab.x;
    Re a = lab.y;
    Re b = lab.z;
    
    Re sl16 = (l + 16.0) / 116.0;
    Re x = Yn * lab_to_xyz_f(sl16);
    Re y = Xn * lab_to_xyz_f(sl16 + a / 500.0);
    Re z = Zn * lab_to_xyz_f(sl16 - b / 200.0);
    
    return Vec3(x, y, z);
}

static Vec3 lab_to_lch(Vec3 lab) {
    Cmplx c = Cmplx(lab.y, lab.z);
    
    return Vec3(lab.x, abs(c), arg(c));
}
static Vec3 lch_to_lab(Vec3 lab) {
    Cmplx c = polar(lab.y, lab.z);
    
    return Vec3(lab.x, real(c), imag(c));
}

static Re lrgb_to_srgb_f(Re t) {
    if (t <= 0.0031308)
        return 12.92 * t;
    return (1 + 0.055) * pow(t, 1.0 / 2.4) - 0.055;
}
static Vec3 lrgb_to_srgb(Vec3 lrgb) {
    return Vec3(lrgb_to_srgb_f(lrgb.x), lrgb_to_srgb_f(lrgb.y), lrgb_to_srgb_f(lrgb.z));
}


static void printcmplx(Cmplx z) {
    printf("(%lf, %lf)\n", real(z), imag(z));
}
static void printre(Re x) {
    printf(" %lf\n", x);
}

static Re sqm(Re t) {
    return sin(fpropermod(t, M_PI_2))
    + cos(fpropermod(t, M_PI_2));
}
static Cmplx cirtosq(Cmplx z) {
    //    printf("c2s\n");
    //    printcmplx(z);
    //    printre(sqrt(2.0));
    //    printre(arg(z));
    //    printre(arg(z) + M_PI_4);
    //    printre(sqm(arg(z) + M_PI_4));
    //    printre(fpropermod(sqm(arg(z) + M_PI_4), M_PI_2));
    //    printre(sqrt(2.0) / sqm(arg(z) + M_PI_4));
    //    printcmplx(z * (sqrt(2.0) / sqm(arg(z) + M_PI_4)));
    
    return z * (sqrt(2.0) / sqm(arg(z) + M_PI_4));
}
static Cmplx sqtocir(Cmplx z) {
    return z * (sqm(arg(z) + M_PI_4) / sqrt(2.0));
}
