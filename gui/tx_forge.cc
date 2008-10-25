/*
        Fractal forgery generator for the PPM toolkit

    Originally  designed  and  implemented  in December of 1989 by
    John Walker as a stand-alone program for the  Sun  and  MS-DOS
    under  Turbo C.  Adapted in September of 1991 for use with Jef
    Poskanzer's raster toolkit.

    References cited in the comments are:

        Foley, J. D., and Van Dam, A., Fundamentals of Interactive
        Computer  Graphics,  Reading,  Massachusetts:  Addison
        Wesley, 1984.

        Peitgen, H.-O., and Saupe, D. eds., The Science Of Fractal
        Images, New York: Springer Verlag, 1988.

        Press, W. H., Flannery, B. P., Teukolsky, S. A., Vetterling,
        W. T., Numerical Recipes In C, New Rochelle: Cambridge
        University Press, 1988.

    Author:
        John Walker
        http://www.fourmilab.ch/

    Permission  to  use, copy, modify, and distribute this software and
    its documentation  for  any  purpose  and  without  fee  is  hereby
    granted,  without any conditions or restrictions.  This software is
    provided "as is" without express or implied warranty.

*/


#include <math.h>
#include <assert.h>

extern "C" {
#include "ppm.h"
}

#ifdef VMS
static double hugeVal = HUGE_VAL;
#else
static double hugeVal = 1e50;
#endif


#define MIN(a,b)  ((a) < (b) ? (a) : (b))
#define MAX(a,b)  ((a) > (b) ? (a) : (b))


/* Definitions used to address real and imaginary parts in a two-dimensional
   array of complex numbers as stored by fourn(). */

#define Real(v, x, y)  v[1 + (((x) * meshsize) + (y)) * 2]
#define Imag(v, x, y)  v[2 + (((x) * meshsize) + (y)) * 2]

/* Co-ordinate indices within arrays. */

typedef struct {
    double x;
    double y;
    double z; 
} vector;

/* Definition for obtaining random numbers. */

#define nrand 4               /* Gauss() sample count */
#define Cast(low, high) ((low)+(((high)-(low)) * ((rand() & 0x7FFF) / arand)))

/* prototypes */
static void fourn (float data[], int nn[], int ndim, int isign);
static void initgauss (unsigned int seed);
static double gauss (void);
static void spectralsynth (float **x, unsigned int n, double h);
static void temprgb (double temp, double *r, double *g, double *b);
static void etoile (pixel *pix);
/*  Local variables  */

static double arand, gaussadd, gaussfac; /* Gaussian random parameters */
static double fracdim;            /* Fractal dimension */
static double powscale;           /* Power law scaling exponent */
static int meshsize = 256;        /* FFT mesh size */
static unsigned int seedarg;        /* Seed specified by user */
static bool seedspec = FALSE;      /* Did the user specify a seed ? */
static bool clouds = FALSE;        /* Just generate clouds */
static bool stars = FALSE;         /* Just generate stars */
static int screenxsize = 256;         /* Screen X size */
static int screenysize = 256;         /* Screen Y size */
static double inclangle, hourangle;   /* Star position relative to planet */
static bool inclspec = FALSE;      /* No inclination specified yet */
static bool hourspec = FALSE;      /* No hour specified yet */
static double icelevel;           /* Ice cap theshold */
static double glaciers;           /* Glacier level */
static int starfraction;          /* Star fraction */
static int starcolor;            /* Star color saturation */

/*  FOURN  --  Multi-dimensional fast Fourier transform

    Called with arguments:

       data       A  one-dimensional  array  of  floats  (NOTE!!!   NOT
              DOUBLES!!), indexed from one (NOTE!!!   NOT  ZERO!!),
              containing  pairs of numbers representing the complex
              valued samples.  The Fourier transformed results  are
              returned in the same array.

       nn         An  array specifying the edge size in each dimension.
              THIS ARRAY IS INDEXED FROM  ONE,  AND  ALL  THE  EDGE
              SIZES MUST BE POWERS OF TWO!!!

       ndim       Number of dimensions of FFT to perform.  Set to 2 for
              two dimensional FFT.

       isign      If 1, a Fourier transform is done; if -1 the  inverse
              transformation is performed.

        This  function  is essentially as given in Press et al., "Numerical
        Recipes In C", Section 12.11, pp.  467-470.
*/

static void fourn(float data[], int nn[], int ndim, int isign)
{
    int i1, i2, i3;
    int i2rev, i3rev, ip1, ip2, ip3, ifp1, ifp2;
    int ibit, idim, k1, k2, n, nprev, nrem, ntot;
    float tempi, tempr;
    double theta, wi, wpi, wpr, wr, wtemp;

#define SWAP(a,b) tempr=(a); (a) = (b); (b) = tempr

    ntot = 1;
    for (idim = 1; idim <= ndim; idim++)
        ntot *= nn[idim];
    nprev = 1;
    for (idim = ndim; idim >= 1; idim--) {
        n = nn[idim];
        nrem = ntot / (n * nprev);
        ip1 = nprev << 1;
        ip2 = ip1 * n;
        ip3 = ip2 * nrem;
        i2rev = 1;
        for (i2 = 1; i2 <= ip2; i2 += ip1) {
            if (i2 < i2rev) {
                for (i1 = i2; i1 <= i2 + ip1 - 2; i1 += 2) {
                    for (i3 = i1; i3 <= ip3; i3 += ip2) {
                        i3rev = i2rev + i3 - i2;
                        SWAP(data[i3], data[i3rev]);
                        SWAP(data[i3 + 1], data[i3rev + 1]);
                    }
                }
            }
            ibit = ip2 >> 1;
            while (ibit >= ip1 && i2rev > ibit) {
                i2rev -= ibit;
                ibit >>= 1;
            }
            i2rev += ibit;
        }
        ifp1 = ip1;
        while (ifp1 < ip2) {
            ifp2 = ifp1 << 1;
            theta = isign * (M_PI * 2) / (ifp2 / ip1);
            wtemp = sin(0.5 * theta);
            wpr = -2.0 * wtemp * wtemp;
            wpi = sin(theta);
            wr = 1.0;
            wi = 0.0;
            for (i3 = 1; i3 <= ifp1; i3 += ip1) {
                for (i1 = i3; i1 <= i3 + ip1 - 2; i1 += 2) {
                    for (i2 = i1; i2 <= ip3; i2 += ifp2) {
                        k1 = i2;
                        k2 = k1 + ifp1;
                        tempr = wr * data[k2] - wi * data[k2 + 1];
                        tempi = wr * data[k2 + 1] + wi * data[k2];
                        data[k2] = data[k1] - tempr;
                        data[k2 + 1] = data[k1 + 1] - tempi;
                        data[k1] += tempr;
                        data[k1 + 1] += tempi;
                    }
                }
                wr = (wtemp = wr) * wpr - wi * wpi + wr;
                wi = wi * wpr + wtemp * wpi + wi;
            }
            ifp1 = ifp2;
        }
        nprev *= n;
    }
}
#undef SWAP

/*  INITGAUSS  --  Initialize random number generators.  As given in
           Peitgen & Saupe, page 77. */

static void initgauss(unsigned int seed)
{
    /* Range of random generator */
    arand = pow(2.0, 15.0) - 1.0;
    gaussadd = sqrt(3.0 * nrand);
    gaussfac = 2 * gaussadd / (nrand * arand);
    srand(seed);
}

/*  GAUSS  --  Return a Gaussian random number.  As given in Peitgen
           & Saupe, page 77. */

static double gauss()
{
    int i;
    double sum = 0.0;

    for (i = 1; i <= nrand; i++) {
        sum += (rand() & 0x7FFF);
    }
    return gaussfac * sum - gaussadd;
}

/*  SPECTRALSYNTH  --  Spectrally  synthesized  fractal  motion in two
               dimensions.  This algorithm is given under  the
               name   SpectralSynthesisFM2D  on  page  108  of
               Peitgen & Saupe. */

static void spectralsynth(
    float **x,
    unsigned int n,
    double h)
{
    unsigned bl;
    int i, j, i0, j0, nsize[3];
    double rad, phase, rcos, rsin;
    float *a;

    bl = ((((unsigned long) n) * n) + 1) * 2 * sizeof(float);
    a = (float *) calloc(bl, 1);
    if (a == (float *) 0) {
        pm_error("Cannot allocate %d x %d result array (% d bytes).",
                 n, n, bl);
    }
    *x = a;

    for (i = 0; i <= n / 2; i++) {
        for (j = 0; j <= n / 2; j++) {
            phase = 2 * M_PI * ((rand() & 0x7FFF) / arand);
            if (i != 0 || j != 0) {
                rad = pow((double) (i * i + j * j), -(h + 1) / 2) * gauss();
            } else {
                rad = 0;
            }
            rcos = rad * cos(phase);
            rsin = rad * sin(phase);
            Real(a, i, j) = rcos;
            Imag(a, i, j) = rsin;
            i0 = (i == 0) ? 0 : n - i;
            j0 = (j == 0) ? 0 : n - j;
            Real(a, i0, j0) = rcos;
            Imag(a, i0, j0) = - rsin;
        }
    }
    Imag(a, n / 2, 0) = 0;
    Imag(a, 0, n / 2) = 0;
    Imag(a, n / 2, n / 2) = 0;
    for (i = 1; i <= n / 2 - 1; i++) {
        for (j = 1; j <= n / 2 - 1; j++) {
            phase = 2 * M_PI * ((rand() & 0x7FFF) / arand);
            rad = pow((double) (i * i + j * j), -(h + 1) / 2) * gauss();
            rcos = rad * cos(phase);
            rsin = rad * sin(phase);
            Real(a, i, n - j) = rcos;
            Imag(a, i, n - j) = rsin;
            Real(a, n - i, j) = rcos;
            Imag(a, n - i, j) = - rsin;
        }
    }

    nsize[0] = 0;
    nsize[1] = nsize[2] = n;          /* Dimension of frequency domain array */
    fourn(a, nsize, 2, -1);       /* Take inverse 2D Fourier transform */
}


static unsigned int initseed(void) {
    /*  Generate initial random seed.  */

    unsigned int i;

    srand(1);
    for (i = 0; i < 7; ++i)
        rand();
    return rand();
}



/*  TEMPRGB  --  Calculate the relative R, G, and B components  for  a
         black  body  emitting  light  at a given temperature.
         The Planck radiation equation is solved directly  for
         the R, G, and B wavelengths defined for the CIE  1931
         Standard    Colorimetric    Observer.    The   color
         temperature is specified in degrees Kelvin. */

static void temprgb(double temp, double *r, double *g, double *b)
{
    double c1 = 3.7403e10,
        c2 = 14384.0,
        er, eg, eb, es;

/* Lambda is the wavelength in microns: 5500 angstroms is 0.55 microns. */

#define Planck(lambda)  ((c1 * pow((double) lambda, -5.0)) /  \
                         (pow(M_E, c2 / (lambda * temp)) - 1))

        er = Planck(0.7000);
        eg = Planck(0.5461);
        eb = Planck(0.4358);
#undef Planck

        es = 1.0 / MAX(er, MAX(eg, eb));

        *r = er * es;
        *g = eg * es;
        *b = eb * es;
}

/*  ETOILE  --  Set a pixel in the starry sky.  */

static void etoile(pixel *pix)
{
    if ((rand() % 1000) < starfraction) {
#define StarQuality 0.5       /* Brightness distribution exponent */
#define StarIntensity   8         /* Brightness scale factor */
#define StarTintExp 0.5       /* Tint distribution exponent */
        double v = StarIntensity * pow(1 / (1 - Cast(0, 0.9999)),
                                       (double) StarQuality),
            temp,
            r, g, b;

        if (v > 255) {
            v = 255;
        }

        /* We make a special case for star color  of zero in order to
           prevent  floating  point  roundoff  which  would  otherwise
           result  in  more  than  256 star colors.  We can guarantee
           that if you specify no star color, you never get more than
           256 shades in the image. */

        if (starcolor == 0) {
            int vi = v;

            PPM_ASSIGN(*pix, vi, vi, vi);
        } else {
            temp = 5500 + starcolor *
                pow(1 / (1 - Cast(0, 0.9999)), StarTintExp) *
                ((rand() & 7) ? -1 : 1);
            /* Constrain temperature to a reasonable value: >= 2600K 
               (S Cephei/R Andromedae), <= 28,000 (Spica). */
            temp = MAX(2600, MIN(28000, temp));
            temprgb(temp, &r, &g, &b);
            PPM_ASSIGN(*pix, (int) (r * v + 0.499),
                       (int) (g * v + 0.499),
                       (int) (b * v + 0.499));
        }
    } else {
        PPM_ASSIGN(*pix, 0, 0, 0);
    }
}



static double uprj(unsigned int  a, unsigned int  size) {

    return (double)a/(size-1);
}



static double atSat(double  x, double  y, double  dsat) {

    return x*(1.0-dsat) + y*dsat;
}



static unsigned char * makeCp(float *a, unsigned int  n, pixval maxval) {

    /* Prescale the grid points into intensities. */

    unsigned char * cp;
    unsigned char * ap;

    if ((1<<30) / n < n)
        pm_error("arithmetic overflow squaring %u", n);
    cp = (unsigned char *)malloc(n * n);
    if (cp == NULL)
        pm_error("Unable to allocate %u bytes for cp array", n);

    ap = cp;
    {
        unsigned int i;
        for (i = 0; i < n; i++) {
            unsigned int j;
            for (j = 0; j < n; j++)
                *ap++ = ((double)maxval * (Real(a, i, j) + 1.0)) / 2.0;
        }
    }
    return cp;
}



static void
createPlanetStuff(float *           a,
                  unsigned int      n,
                  double **         uP,
                  double **         u1P,
                  unsigned int **   bxfP,
                  unsigned int **   bxcP,
                  unsigned char **  cpP,
                  vector *          sunvecP,
                  unsigned int      cols,
                  pixval            maxval) {

    double *u, *u1;
    unsigned int *bxf, *bxc;
    unsigned char * cp;
    double shang, siang;
    bool flipped;

    /* Compute incident light direction vector. */

    shang = hourspec ? hourangle : Cast(0, 2 * M_PI);
    siang = inclspec ? inclangle : Cast(-M_PI * 0.12, M_PI * 0.12);

    sunvecP->x = sin(shang) * cos(siang);
    sunvecP->y = sin(siang);
    sunvecP->z = cos(shang) * cos(siang);  /* initial value */

    /* Allow only 25% of random pictures to be crescents */

    if (!hourspec && ((rand() % 100) < 75)) {
        flipped = (sunvecP->z < 0);
        sunvecP->z = fabs(sunvecP->z);
    } else
        flipped = FALSE;

    if (!clouds) {
        pm_message(
            "        -inclination %.0f -hour %d -ice %.2f -glaciers %.2f",
            (siang * (180.0 / M_PI)),
            (int) (((shang * (12.0 / M_PI)) + 12 +
                    (flipped ? 12 : 0)) + 0.5) % 24, icelevel, glaciers);
        pm_message("        -stars %d -saturation %d.",
                   starfraction, starcolor);
    }

    cp = makeCp(a, n, maxval);

    /* Fill the screen from the computed  intensity  grid  by  mapping
       screen  points onto the grid, then calculating each pixel value
       by bilinear interpolation from  the  surrounding  grid  points.
       (N.b. the pictures would undoubtedly look better when generated
       with small grids if  a  more  well-behaved  interpolation  were
       used.)
       
       Also compute the line-level interpolation parameters that
       caller will need every time around his inner loop.  
    */

    u  = new double[cols];
    u1 = new double[cols];
    
    bxf = new unsigned int[cols];
    bxc = new unsigned int[cols];
    
    if (u == NULL || u1 == NULL || bxf == NULL || bxc == NULL) 
        pm_error("Cannot allocate %d element interpolation tables.", cols);
    {
        unsigned int j;
        for (j = 0; j < cols; j++) {
            double bx = (n - 1) * uprj(j, cols);
            
            bxf[j] = floor(bx);
            bxc[j] = bxf[j] + 1;
            u[j] = bx - bxf[j];
            u1[j] = 1 - u[j];
        }
    }
    *uP   = u;  *u1P  = u1;
    *bxfP = bxf; *bxcP = bxc;
    *cpP  = cp;
}



static void
generateStarrySkyRow(pixel *       pixels, 
                     unsigned int  cols) {
/*----------------------------------------------------------------------------
  Generate a starry sky.  Note  that no FFT is performed;
  the output is  generated  directly  from  a  power  law
  mapping  of  a  pseudorandom sequence into intensities. 
-----------------------------------------------------------------------------*/
    unsigned int j;
    
    for (j = 0; j < cols; j++)
        etoile(pixels + j);
}



static void
generateCloudRow(pixel *          pixels,
                 unsigned int     cols,
                 double           t,
                 double           t1,
                 double *         u,
                 double *         u1,
                 unsigned char *  cp,
                 unsigned int *   bxc,
                 unsigned int *   bxf,
                 int              byc,
                 int              byf,
                 pixval           maxval) {

    /* Render the FFT output as clouds. */

    unsigned int j;

    for (j = 0; j < cols; j++) {
        double r;
        pixval w;
        
        r = 0.0;  /* initial value */
        /* Note that where t1 and t are zero, the cp[] element
           referenced below does not exist.
        */
        if (t1 > 0.0)
            r += t1 * u1[j] * cp[byf + bxf[j]] +
                t1 * u[j]  * cp[byf + bxc[j]];
        if (t > 0.0)
            r += t * u1[j] * cp[byc + bxf[j]] +
                t * u[j]  * cp[byc + bxc[j]];
        
        w = (r > 127.0) ? (maxval * ((r - 127.0) / 128.0)) : 0;
        
        PPM_ASSIGN(*(pixels + j), w, w, maxval);
    }
}



static void
makeLand(int *   irP,
         int *   igP,
         int *   ibP,
         double  r) {
/*----------------------------------------------------------------------------
  Land area.  Look up color based on elevation from precomputed
  color map table.
-----------------------------------------------------------------------------*/
    static unsigned char pgnd[][3] = {
        {206, 205, 0}, {208, 207, 0}, {211, 208, 0},
        {214, 208, 0}, {217, 208, 0}, {220, 208, 0},
        {222, 207, 0}, {225, 205, 0}, {227, 204, 0},
        {229, 202, 0}, {231, 199, 0}, {232, 197, 0},
        {233, 194, 0}, {234, 191, 0}, {234, 188, 0},
        {233, 185, 0}, {232, 183, 0}, {231, 180, 0},
        {229, 178, 0}, {227, 176, 0}, {225, 174, 0},
        {223, 172, 0}, {221, 170, 0}, {219, 168, 0},
        {216, 166, 0}, {214, 164, 0}, {212, 162, 0},
        {210, 161, 0}, {207, 159, 0}, {205, 157, 0},
        {203, 156, 0}, {200, 154, 0}, {198, 152, 0},
        {195, 151, 0}, {193, 149, 0}, {190, 148, 0},
        {188, 147, 0}, {185, 145, 0}, {183, 144, 0},
        {180, 143, 0}, {177, 141, 0}, {175, 140, 0},
        {172, 139, 0}, {169, 138, 0}, {167, 137, 0},
        {164, 136, 0}, {161, 135, 0}, {158, 134, 0},
        {156, 133, 0}, {153, 132, 0}, {150, 132, 0},
        {147, 131, 0}, {145, 130, 0}, {142, 130, 0},
        {139, 129, 0}, {136, 128, 0}, {133, 128, 0},
        {130, 127, 0}, {127, 127, 0}, {125, 127, 0},
        {122, 127, 0}, {119, 127, 0}, {116, 127, 0},
        {113, 127, 0}, {110, 128, 0}, {107, 128, 0},
        {104, 128, 0}, {102, 127, 0}, { 99, 126, 0},
        { 97, 124, 0}, { 95, 122, 0}, { 93, 120, 0},
        { 92, 117, 0}, { 92, 114, 0}, { 92, 111, 0},
        { 93, 108, 0}, { 94, 106, 0}, { 96, 104, 0},
        { 98, 102, 0}, {100, 100, 0}, {103,  99, 0},
        {106,  99, 0}, {109,  99, 0}, {111, 100, 0},
        {114, 101, 0}, {117, 102, 0}, {120, 103, 0},
        {123, 102, 0}, {125, 102, 0}, {128, 100, 0},
        {130,  98, 0}, {132,  96, 0}, {133,  94, 0},
        {134,  91, 0}, {134,  88, 0}, {134,  85, 0},
        {133,  82, 0}, {131,  80, 0}, {129,  78, 0}
    };

    unsigned int ix = ((r - 128) * ((90) - 1)) / 127;
    
    *irP = pgnd[ix][0];
    *igP = pgnd[ix][1];
    *ibP = pgnd[ix][2];
} 



static void
makeWater(int *   irP,
          int *   igP,
          int *   ibP,
          double  r,
          pixval  maxval) {

    /* Water.  Generate clouds above water based on elevation.  */

    *irP = *igP = r > 64 ? (r - 64) * 4 : 0;
    *ibP = maxval;
}



static void
addIce(int *   irP,
       int *   igP,
       int *   ibP,
       double  r,
       double  azimuth,
       double  icelevel,
       double  glaciers,
       pixval  maxval) {

    /* Generate polar ice caps. */
    
    double icet = pow(fabs(sin(azimuth)), 1.0 / icelevel) - 0.5;
    double ice = MAX(0.0, 
                           (icet + glaciers * MAX(-0.5, (r - 128) / 128.0)));
    if  (ice > 0.125) {
        *irP = maxval;
        *igP = maxval;
        *ibP = maxval;
    }
}



static void
limbDarken(int *          irP,
           int *          igP,
           int *          ibP,
           unsigned int   col,
           unsigned int   row,
           unsigned int   cols,
           unsigned int   rows,
           vector         sunvec,
           pixval         maxval) {

    /* With Gcc 2.95.3 compiler optimization level > 1, I have seen this
       function confuse all the variables and ultimately generate a 
       completely black image.  Adding an extra reference to 'rows' seems
       to put things back in order, and the assert() below does that.
       Take it out, and the problem comes back!  04.02.21.
    */

    /* Apply limb darkening by cosine rule. */

    double atthick  = 1.03;
    double atSatFac = 1.0;
    double athfac   = sqrt(atthick * atthick - 1.0);
        /* Atmosphere thickness as a percentage of planet's diameter */

    double dy = 2 * ((double)rows/2 - row) / rows;
    double dysq = dy * dy;
    /* Note: we are in fact normalizing this horizontal position by the
       vertical size of the picture.  And we know rows >= cols.
    */
    double dx   = 2 * ((double)cols/2 - col) / rows;
    double dxsq = dx * dx;

    double ds = MIN(1.0, sqrt(dxsq + dysq));
    
    /* Calculate atmospheric absorption based on the thickness of
       atmosphere traversed by light on its way to the surface.  
    */
    double dsq = ds * ds;
    double dsat = atSatFac * ((sqrt(atthick * atthick - dsq) -
                                     sqrt(1.0 * 1.0 - dsq)) / athfac);

    assert(rows >= cols);  /* An input requirement */

    *irP = atSat(*irP, maxval/2, dsat);
    *igP = atSat(*igP, maxval/2, dsat);
    *ibP = atSat(*ibP, maxval,   dsat);
    {
        double PlanetAmbient = 0.05;

        double sqomdysq = sqrt(1.0 - dysq);
        double svx = sunvec.x;
        double svy = sunvec.y * dy;
        double svz = sunvec.z * sqomdysq;
        double di = 
            MAX(0, MIN(1.0, svx * dx + svy + svz * sqrt(1.0 - dxsq)));
        double inx = PlanetAmbient * 1.0 + (1.0 - PlanetAmbient) * di;

        *irP *= inx;
        *igP *= inx;
        *ibP *= inx;
    }
}



static void
generatePlanetRow(pixel *         pixelrow,
                  unsigned int    row,
                  unsigned int    rows,
                  unsigned int    cols,
                  double          t,
                  double          t1,
                  double *        u,
                  double *        u1,
                  unsigned char * cp,
                  unsigned int *  bxc,
                  unsigned int *  bxf,
                  int             byc,
                  int             byf,
                  vector          sunvec,
                  pixval          maxval) {

    unsigned int StarClose = 2;

    double azimuth    = asin(((((double) row) / (rows - 1)) * 2) - 1);
    unsigned int lcos = (rows / 2) * fabs(cos(azimuth));

    unsigned int col;

    for (col = 0; col < cols; ++col)
        PPM_ASSIGN(pixelrow[col], 0, 0, 0);

    for (col = cols/2 - lcos; col <= cols/2 + lcos; ++col) {
        double r;
        int ir, ig, ib;

        r = 0.0;   /* initial value */
        
        /* Note that where t1 and t are zero, the cp[] element
           referenced below does not exist.  
        */
        if (t1 > 0.0)
            r += t1 * u1[col] * cp[byf + bxf[col]] +
                t1 * u[col]  * cp[byf + bxc[col]];
        if (t > 0.0)
            r += t * u1[col] * cp[byc + bxf[col]] +
                t * u[col]  * cp[byc + bxc[col]];

        if (r >= 128) 
            makeLand(&ir, &ig, &ib, r);
        else 
            makeWater(&ir, &ig, &ib, r, maxval);

        addIce(&ir, &ig, &ib, r, azimuth, icelevel, glaciers, maxval);

        limbDarken(&ir, &ig, &ib, col, row, cols, rows, sunvec, maxval);

        PPM_ASSIGN(pixelrow[col], ir, ig, ib);
    }

    /* Left stars */

    for (col = 0; (int)col < (int)(cols/2 - (lcos + StarClose)); ++col)
        etoile(&pixelrow[col]);

    /* Right stars */

    for (col = cols/2 + (lcos + StarClose); col < cols; ++col)
        etoile(&pixelrow[col]);
}



static void 
genplanet(bool         stars,
          bool         clouds,
          float *      a, 
          unsigned int cols,
          unsigned int rows,
          unsigned int n,
          unsigned int rseed) {
/*----------------------------------------------------------------------------
  Generate planet from elevation array.

  If 'stars' is true, a is undefined.  Otherwise, it is defined.
-----------------------------------------------------------------------------*/
    pixval maxval = PPM_MAXMAXVAL;

    unsigned char *cp;
    double *u, *u1;
    unsigned int *bxf, *bxc;

    pixel *pixelrow;
    unsigned int row;

    vector sunvec;

    ppm_writeppminit(stdout, cols, rows, maxval, FALSE);

    if (stars) {
        pm_message("night: -seed %d -stars %d -saturation %d.",
                   rseed, starfraction, starcolor);
        cp = NULL; 
        u = NULL; u1 = NULL;
        bxf = NULL; bxc = NULL;
    } else {
        pm_message("%s: -seed %d -dimension %.2f -power %.2f -mesh %d",
                   clouds ? "clouds" : "planet",
                   rseed, fracdim, powscale, meshsize);
        createPlanetStuff(a, n, &u, &u1, &bxf, &bxc, &cp, &sunvec, 
                          cols, maxval);
    }

    pixelrow = ppm_allocrow(cols);
    for (row = 0; row < rows; ++row) {
        if (stars)
            generateStarrySkyRow(pixelrow, cols);
        else {
            double by = (n - 1) * uprj(row, rows);
            int    byf = floor(by) * n;
            int    byc = byf + n;
            double t = by - floor(by);
            double t1 = 1 - t;

            if (clouds)
                generateCloudRow(pixelrow, cols,
                                 t, t1, u, u1, cp, bxc, bxf, byc, byf,
                                 maxval);
            else 
                generatePlanetRow(pixelrow, row, rows, cols,
                                  t, t1, u, u1, cp, bxc, bxf, byc, byf,
                                  sunvec,
                                  maxval);
        }
        ppm_writeppmrow(stdout, pixelrow, cols, maxval, FALSE);
    }
    pm_close(stdout);

    ppm_freerow(pixelrow);
//    if (cp)  free(cp);
//    if (u)   free(u);
//    if (u1)  free(u1);
//    if (bxf) free(bxf);
//    if (bxc) free(bxc);
}



static void
applyPowerLawScaling(float * a,
                     int     meshsize,
                     double  powscale) {

    /* Apply power law scaling if non-unity scale is requested. */
    
    if (powscale != 1.0) {
        unsigned int i;
        for (i = 0; i < meshsize; i++) {
            unsigned int j;
            for (j = 0; j < meshsize; j++) {
                double r = Real(a, i, j);
                if (r > 0)
                    Real(a, i, j) = pow(r, powscale);
            }
        }
    }
}



static void
computeExtremeReal(const float * a,
                   int           meshsize,
                   double *      rminP,
                   double *      rmaxP) {
    
    /* Compute extrema for autoscaling. */

    double rmin, rmax;
    unsigned int i;

    rmin = hugeVal;
    rmax = -hugeVal;

    for (i = 0; i < meshsize; i++) {
        unsigned int j;
        for (j = 0; j < meshsize; j++) {
            double r = Real(a, i, j);
            
            rmin = MIN(rmin, r);
            rmax = MAX(rmax, r);
        }
    }
    *rminP = rmin;
    *rmaxP = rmax;
}



static void
replaceWithSpread(float * a,
                  int     meshsize) {
/*----------------------------------------------------------------------------
  Replace the real part of each element of the 'a' array with a
  measure of how far the real is from the middle; sort of a standard
  deviation.
-----------------------------------------------------------------------------*/
    double rmin, rmax;
    double rmean, rrange;
    unsigned int i;

    computeExtremeReal(a, meshsize, &rmin, &rmax);

    rmean = (rmin + rmax) / 2;
    rrange = (rmax - rmin) / 2;

    for (i = 0; i < meshsize; i++) {
        unsigned int j;
        for (j = 0; j < meshsize; j++) {
            Real(a, i, j) = (Real(a, i, j) - rmean) / rrange;
        }
    }
}



static bool
planet(unsigned int cols,
       unsigned int rows,
       bool         stars,
       bool         clouds) {
/*----------------------------------------------------------------------------
   Make a planet.
-----------------------------------------------------------------------------*/
    float * a;
    bool error;
    unsigned int rseed;        /* Current random seed */
    
    if (seedspec)
        rseed = seedarg;
    else 
        rseed = initseed();
    
    initgauss(rseed);
    
    if (stars) {
        a = NULL;
        error = FALSE;
    } else {
        spectralsynth(&a, meshsize, 3.0 - fracdim);
        if (a == NULL) {
            error = TRUE;
        } else {
            applyPowerLawScaling(a, meshsize, powscale);
                
            replaceWithSpread(a, meshsize);

            error = FALSE;
        }
    }
    if (!error)
        genplanet(stars, clouds, a, cols, rows, meshsize, rseed);

//    if (a != NULL)
//        free(a);

    return !error;
}




int main(int argc, char ** argv) {

    bool success;
    int i;
    char * usage = "\n\
[-width|-xsize <x>] [-height|-ysize <y>] [-mesh <n>]\n\
[-clouds] [-dimension <f>] [-power <f>] [-seed <n>]\n\
[-hour <f>] [-inclination|-tilt <f>] [-ice <f>] [-glaciers <f>]\n\
[-night] [-stars <n>] [-saturation <n>]";
    bool dimspec = FALSE, meshspec = FALSE, powerspec = FALSE,
        widspec = FALSE, hgtspec = FALSE, icespec = FALSE,
        glacspec = FALSE, starspec = FALSE, starcspec = FALSE;

    int cols, rows;     /* Dimensions of our output image */

    ppm_init(&argc, argv);
    i = 1;
    
    while ((i < argc) && (argv[i][0] == '-') && (argv[i][1] != '\0')) {

        if (pm_keymatch(argv[i], "-clouds", 2)) {
            clouds = TRUE;
        } else if (pm_keymatch(argv[i], "-night", 2)) {
            stars = TRUE;
        } else if (pm_keymatch(argv[i], "-dimension", 2)) {
            if (dimspec) {
                pm_error("already specified a dimension");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &fracdim)  != 1))
                pm_usage(usage);
            if (fracdim <= 0.0) {
                pm_error("fractal dimension must be greater than 0");
            }
            dimspec = TRUE;
        } else if (pm_keymatch(argv[i], "-hour", 3)) {
            if (hourspec) {
                pm_error("already specified an hour");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &hourangle) != 1))
                pm_usage(usage);
            hourangle = (M_PI / 12.0) * (hourangle + 12.0);
            hourspec = TRUE;
        } else if (pm_keymatch(argv[i], "-inclination", 3) ||
                   pm_keymatch(argv[i], "-tilt", 2)) {
            if (inclspec) {
                pm_error("already specified an inclination/tilt");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &inclangle) != 1))
                pm_usage(usage);
            inclangle = (M_PI / 180.0) * inclangle;
            inclspec = TRUE;
        } else if (pm_keymatch(argv[i], "-mesh", 2)) {
            unsigned int j;

            if (meshspec) {
                pm_error("already specified a mesh size");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%d", &meshsize) != 1))
                pm_usage(usage);

            /* Force FFT mesh to the next larger power of 2. */

            for (j = meshsize; (j & 1) == 0; j >>= 1) ;

            if (j != 1) {
                for (j = 2; j < meshsize; j <<= 1) ;
                meshsize = j;
            }
            meshspec = TRUE;
        } else if (pm_keymatch(argv[i], "-power", 2)) {
            if (powerspec) {
                pm_error("already specified a power factor");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &powscale) != 1))
                pm_usage(usage);
            if (powscale <= 0.0) {
                pm_error("power factor must be greater than 0");
            }
            powerspec = TRUE;
        } else if (pm_keymatch(argv[i], "-ice", 3)) {
            if (icespec) {
                pm_error("already specified ice cap level");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &icelevel) != 1))
                pm_usage(usage);
            if (icelevel <= 0.0) {
                pm_error("ice cap level must be greater than 0");
            }
            icespec = TRUE;
        } else if (pm_keymatch(argv[i], "-glaciers", 2)) {
            if (glacspec) {
                pm_error("already specified glacier level");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%lf", &glaciers) != 1))
                pm_usage(usage);
            if (glaciers <= 0.0) {
                pm_error("glacier level must be greater than 0");
            }
            glacspec = TRUE;
        } else if (pm_keymatch(argv[i], "-stars", 3)) {
            if (starspec) {
                pm_error("already specified a star fraction");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%d", &starfraction) != 1))
                pm_usage(usage);
            starspec = TRUE;
        } else if (pm_keymatch(argv[i], "-saturation", 3)) {
            if (starcspec) {
                pm_error("already specified a star color saturation");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%d", &starcolor) != 1))
                pm_usage(usage);
            starcspec = TRUE;
        } else if (pm_keymatch(argv[i], "-seed", 3)) {
            if (seedspec) {
                pm_error("already specified a random seed");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%u", &seedarg) != 1))
                pm_usage(usage);
            seedspec = TRUE;
        } else if (pm_keymatch(argv[i], "-xsize", 2) ||
                   pm_keymatch(argv[i], "-width", 2)) {
            if (widspec) {
                pm_error("already specified a width/xsize");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%d", &screenxsize) != 1))
                pm_usage(usage);
            widspec = TRUE;
        } else if (pm_keymatch(argv[i], "-ysize", 2) ||
                   pm_keymatch(argv[i], "-height", 3)) {
            if (hgtspec) {
                pm_error("already specified a height/ysize");
            }
            i++;
            if ((i == argc) || (sscanf(argv[i], "%d", &screenysize) != 1))
                pm_usage(usage);
            hgtspec = TRUE;
        } else {
            pm_usage(usage);
        }
        i++;
    }


    /* Set defaults when explicit specifications were not given.

       The  default  fractal  dimension  and  power  scale depend upon
       whether we are generating a planet or clouds. 
    */
    
    if (!dimspec) {
        fracdim = clouds ? 2.15 : 2.4;
    }
    if (!powerspec) {
        powscale = clouds ? 0.75 : 1.2;
    }
    if (!icespec) {
        icelevel = 0.4;
    }
    if (!glacspec) {
        glaciers = 0.75;
    }
    if (!starspec) {
        starfraction = 100;
    }
    if (!starcspec) {
        starcolor = 125;
    }

    /* Force  screen to be at least  as wide as it is high.  Long,
       skinny screens  cause  crashes  because  picture  width  is
       calculated based on height.  
    */

    cols = (MAX(screenysize, screenxsize) + 1) & (~1);
    rows = screenysize;

    success = planet(cols, rows, stars, clouds);

    exit(success ? 0 : 1);
}
