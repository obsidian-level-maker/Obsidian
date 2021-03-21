#include <memory.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define M_PI                3.14159265358979323846

unsigned int ComputeAngle(int dx, int dy) {
        float w;

        w = (atan2( (float) dy , (float) dx) * (float)(65536/(M_PI*2)));

        if(w<0) w = (float)65536+w;

        return (unsigned) w;
}

int smallerFraction(float *a, float *b) {


	int max;

	int i_a = (int) *a;
	int i_b = (int) *b;

	if (abs(i_a) > abs(i_b)) {
		max = i_b;
	} else {
		max = i_a;
	}

	for (int i = max; i >= 2; i--) {
		if ( (i_a % i == 0) && ( i_b % i) == 0) {
			i_a = i_a / i;
			i_b = i_b / i;
		}
	}

	*a = (float) i_a;
	*b = (float) i_b;

}

float distance(int sx, int sy, int ex, int ey, int px, int py);


//int summary(int argc, const char *argv [] ) {
int summary(float sx, float sy, float ex, float ey, int points, char *argv []) {

		float px;
		float py;

		float dist;
		
		printf("\nPartition data of partition from  %6.0f,%-6.0f to %6.0f,%-6.0f)\n\n", sx, sy, ex, ey);
		printf("Part X | Part Y | X Diff | Y Diff |\n");
		printf("%-6.0f | %-6.0f | %-6.0f | %-6.0f |\n\n", sx, sy, ex - sx, ey - sy);

		for (int p = 0; p != points; p++) {
			px = atoi(argv[(p * 2)+ 5]);
			py = atoi(argv[(p * 2)+ 6]);
			
			float upper = abs(((ey - sy) * px) - ((ex -sx) * py) + (ex * sy) - (ey * sx));
			float below = sqrt( pow(ey - sy, 2) + pow(ex - sx, 2));

			dist = upper / below;

			// dist = distance(sx, sy, ey, ex, px, py);

			printf("Distance from point #%-2d (%5.0f,%-5.0f) to line: %10.8f", p + 1, px, py, dist);

			if (dist > 1.3) {
				printf(" ! Bad rounding, should have inserted a seg?");
			} else 	if (dist > 0.5) {
				printf(" ! Minor slime trail!");
			} else if (dist > 0.28) {
				printf(" ! Thin slime trail.");
			} else {
				printf(" - All good!");
			}
			
			printf("\n");			


		}
		printf("\n");
		// printf("------------------\n");
}

float distance(int sx, int sy, int ex, int ey, int px, int py) {
	float upper = abs(((ey - sy ) * px) - ((ex - sx ) * py) + (ex  * sy ) - (ey * sx ));
	float below = sqrt( pow( ey - sy,  2) + pow(ex - sx, 2));

	return upper / below;	

}

float length (int sx, int sy, int ex, int ey) {
	return sqrt(pow(ex-sx,2) + pow(ey-sy,2)); 
}

int main ( int argc, char *argv [] ) {

	if (argc < 6) {
		printf("Expected at least 6 arguments, start_X start_Y diff_X diff_Y point_X point_Y\n");
		return 1;
	} else {
		float sx = atoi(argv[1]);
		float sy = atoi(argv[2]);
		float dx = atoi(argv[3]);
		float dy = atoi(argv[4]);

		float px; 
		float py; 

		float dist;

		int points = (argc - 4) / 2;
/*
		printf("Partition data: %4.0f,%-4.0f | %4.0f,%-4.0f\n", sx, sy, ex, ey);
		printf("Line from: %4.0f,%-4.0f to %4.0f,%-4.0f\n", sx, sy, sx + ex, sy + ey);
*/
		// summary(argc, argv);
		summary (sx, sy, dx, dy, points, argv);


		// Compute optimization...
		
		float baddies = 9999;
		float worst = 9999;


		int sx_diff, sx_diff_best;
		int sy_diff, sy_diff_best;
		int ex_diff, ex_diff_best;
		int ey_diff, ey_diff_best;


		int belows = 0;
		int belows_best = 0;
		
		float dist_worst_best = 999.9;
		
		int ex = sx + dx;
		int ey = sy + dy;

		float dist_worst = 0.0;
		float dist_best ;

		int pointsArray[argc];

		int rounds = 0;

		for (int p = 0; p != argc; p++) {
			pointsArray[p] = atoi(argv[p]);
		}

		#define START -80
		#define END 80


		// Scale up!
		
		bool scale = true;
		
		printf("Expect %d indicators: \n", END - START);
		printf("[%*s]\n ", END - START + 1, (const char *) "");
		setbuf(stdout, NULL);
		
		char ic = '-';

		for (sx_diff = START; sx_diff <= END; sx_diff++) {
			// printf("%d of %d\n", sx_diff + END, END - START);
			printf("%c", ic);
			
			ic = '-';
			
		
			for (sy_diff = -140; sy_diff <= 140; sy_diff++) {
				for (ex_diff = -140; ex_diff <= 140; ex_diff++) {
					for (ey_diff = -140; ey_diff <= 140; ey_diff++) {

						belows = 0;
						dist_worst = 0.0;
						dist_best = 999.9;

						for (int p = 0; p != points; p++) {

							// px = atoi(argv[(p * 2)+ 5]);
							// py = atoi(argv[(p * 2)+ 6]);

							float px = pointsArray[p * 2 + 5];
							float py = pointsArray[(p * 2)+ 6];
/*
							if (px != px2) {
								printf("px %f px2 %f\n", px, px2);
								exit(0);
							}
*/
							dist = distance(sx + sx_diff, sy + sy_diff, ex + ex_diff, ey + ey_diff, px, py);
					
							if (dist < 0.28) {
								belows++;
							}

							if (dist > dist_worst) {
								dist_worst = dist;
							} 
							if (dist_best > dist) {
								dist_best = dist;	
							}
							
							

						}

						rounds++;						

						// This is a VERY important optimization.
						if (dist_best > 0) {
							ey_diff += dist_best;
						}


						if ((belows > belows_best) || ((belows == belows_best) && (dist_worst < dist_worst_best)))  {

							sx_diff_best = sx_diff;
							sy_diff_best = sy_diff;
							
							ey_diff_best = ey_diff;
							ex_diff_best = ex_diff;								

							dist_worst_best = dist_worst;

							belows_best = belows;
							
							// printf("better sx %d sy %d  belows %d dist_worst %f dx %d  dy %d \n", sx_diff, sy_diff, belows, dist_worst_best, ex_diff, ey_diff);
							ic = '+';
														

							// summary(sx + sx_diff, sy + sy_diff, ex + ex_diff, ey + ey_diff, points, argv);
						}
					}
				}
			}

		}
		printf("\n");

		sx += sx_diff_best;
		sy += sy_diff_best;

		ex += ex_diff_best;
		ey += ey_diff_best;	

		dx = ex - sx;
		dy = ey - sy;
	
/*
		dx += dx_diff_best;
		dy += dy_diff_best;
*/


		//printf("\nOptimized partition %d %d %d %d\n", sx_diff_best, sy_diff_best, ex_diff_best, ey_diff_best);
		
		//printf("Fraction %f %f\n", dx, dy);
		smallerFraction(&dx, &dy);

		//printf("Fraction %f %f\n", dx, dy);

		ex = sx + dx;
		ey = sy + dy;

		//printf("\nOptimized partition %d %d %d %d\n", sx_diff_best, sy_diff_best, ex, ey);

		bool optimizable = true;

		int c = 0;

		while (optimizable) {
			optimizable = false;
		
			int pre = abs(sx) + abs(sy);

			int changed_plus = (abs(sx - dx) + abs(sy - dy));
			int changed_minus = (abs(sx + dx) + abs(sy + dy));

			// printf("Pre er %d, %d, %d\n", pre, changed_plus, changed_minus);

			if ( changed_minus < pre) {
				sx += dx;
				sy += dy;
				
				ex += dx;
				ey += dy;

				optimizable = true;
				//printf("minus\n");
			} else if (changed_plus < pre) {
				sx -= dx;
				sy -= dy;

				ex -= dx;
				ey -= dy;
			
				optimizable = true;				
				// printf("plus\n");
			}

			c++;

			if (c == 5) {
				break;
			}

		}

		summary (sx, sy, ex, ey, points, argv);

		printf("Rounds %d\n", rounds);

		// scale to about max 10k 



	}
}
