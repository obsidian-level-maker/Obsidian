#include <memory.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>


#define M_PI                3.14159265358979323846

unsigned int ComputeAngle(int dx, int dy) {
        double w;

        w = (atan2( (double) dy , (double) dx) * (double)(65536/(M_PI*2)));

        if(w<0) w = (double)65536+w;

        return (unsigned) w;
}

int main ( int argc, const char *argv [] ) {

	if (argc != 5) {
		printf("Expected 4 arguments, startx starty endx endy\n");
		return 1;
	} else {
		int sx = atoi(argv[1]);
		int sy = atoi(argv[2]);
		int ex = atoi(argv[3]);
		int ey = atoi(argv[4]);
		
		int angle = ComputeAngle(ex - sx, ey - sy);
		int backside = (angle + 32768) % 65536;

		int sladeAngle = angle;
		int sladeBackside = backside;	
	
		if (angle > 32767) {
			sladeAngle = angle - 65536;
		}
		if (backside > 32767) {
			sladeBackside = backside - 65536;
		}

	

		printf("Frontside angle: %5d. Backside %5d\n", angle, backside);
		printf("Signed BAM:      %5d.          %5d\n", sladeAngle, sladeBackside);

	}

	
}
