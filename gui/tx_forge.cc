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


/* Ripped apart to use in OBLIGE by Andrew Apted, October 2008 */


#include "headers.h"

#include "lib_util.h"
#include "main.h"

#include "tx_forge.h"


/* Definitions used to address real and imaginary parts in a two-dimensional
   array of complex numbers as stored by fourn(). */

#define Real(v, x, y)  v[1 + (((x) * meshsize) + (y)) * 2]
#define Imag(v, x, y)  v[2 + (((x) * meshsize) + (y)) * 2]

/* Co-ordinate indices within arrays. */


/* Definition for obtaining random numbers. */

#define nrand 4               /* Gauss() sample count */
#define Cast(low, high) ((low)+(((high)-(low)) * ((rand() & 0x7FFF) / arand)))

/* prototypes */
static void fourn (float data[], int nn[], int ndim, int isign);
static void initgauss (unsigned int seed);
static double gauss (void);
static void spectralsynth (float **x, int n, double h);

/*  Local variables  */

static double arand, gaussadd, gaussfac; /* Gaussian random parameters */
static double fracdim;            /* Fractal dimension */
static double powscale;           /* Power law scaling exponent */
static int meshsize = 256;        /* FFT mesh size */



static int screenxsize = 256;         /* Screen X size */
static int screenysize = 256;         /* Screen Y size */





/*  FOURN  --  Multi-dimensional fast Fourier transform

    Called with arguments:

       data   A  one-dimensional  array  of  floats  (NOTE!!!  NOT
              DOUBLES!!), indexed from one (NOTE!!! NOT  ZERO!!),
              containing  pairs of numbers representing the complex
              valued samples.  The Fourier transformed results  are
              returned in the same array.

       nn     An  array specifying the edge size in each dimension.
              THIS ARRAY IS INDEXED FROM  ONE,  AND  ALL  THE  EDGE
              SIZES MUST BE POWERS OF TWO!!!

       ndim   Number of dimensions of FFT to perform.  Set to 2 for
              two dimensional FFT.

       isign  If 1, a Fourier transform is done; if -1 the  inverse
              transformation is performed.

    This function is essentially as given in Press et al., "Numerical
    Recipes In C", Section 12.11, pp. 467-470.
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

static void spectralsynth( float **x, int n, double h)
{
    unsigned int bl;
    int i, j, i0, j0, nsize[3];
    double rad, phase, rcos, rsin;
    float *a;

    bl = ((((unsigned long) n) * n) + 1) * 2;
    a = new float [bl];
    memset(a, 0, sizeof(float) * bl);

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



static void
applyPowerLawScaling(float * a,
                     int     meshsize,
                     double  powscale) {

    /* Apply power law scaling if non-unity scale is requested. */

  int i;
  int j;
  for (i = 0; i < meshsize; i++) {
    for (j = 0; j < meshsize; j++) {
      double r = Real(a, i, j);
      if (r > 0)
        Real(a, i, j) = pow(r, powscale);
    }
  }
}


static void
scaleMesh_0to1(float * a,
                  int     meshsize)
{
    /* compute extrema for autoscaling. */
    double rmin =  1e30;
    double rmax = -1e30;

    int i, j;
    for (i = 0; i < meshsize; i++) {
        for (j = 0; j < meshsize; j++) {
            double r = Real(a, i, j);
            
            rmin = MIN(rmin, r);
            rmax = MAX(rmax, r);
        }
    }

    double range = (rmax - rmin);

    for (i = 0; i < meshsize; i++) {
        for (j = 0; j < meshsize; j++) {
            Real(a, i, j) = (Real(a, i, j) - rmin) / range;
        }
    }
}


void foo(int argc, char ** argv)
{

    int cols, rows;     /* Dimensions of our output image */


    /* Set defaults when explicit specifications were not given.

       The  default  fractal  dimension  and  power  scale depend upon
       whether we are generating a planet or clouds. 
    */
    
      fracdim = 2.4;

      powscale = 1.2;


    cols = screenxsize;
    rows = screenysize;


    unsigned int rseed;        /* Current random seed */
    

      rseed = initseed();
    
    initgauss(rseed);
    
    float * a;
      
    spectralsynth(&a, meshsize, 3.0 - fracdim);

    //        applyPowerLawScaling(a, meshsize, powscale);

            scaleMesh_0to1(a, meshsize);

}


void TX_SpectralSynth(int seed, float *buf, int width,
                      double fracdim, double powscale)
{
  // TODO
}

