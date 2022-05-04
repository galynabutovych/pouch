#include <iostream>
#include <stdio.h>
#include <array>
#include <cstdlib>
#include <unistd.h>
#include <math.h>

static FILE *gnuplot_fd;

static constexpr int N1 = 10;
static constexpr int N2 = 10;
static constexpr int N3 = 10;

static constexpr double B = 10;
static long long int M = 0;

static std::array<std::array<std::array<bool, N1>, N2>, N3> s;

void init_plot()
{
	if ( ( gnuplot_fd = popen( "gnuplot", "w" ) ) == NULL )
	{
		fprintf( stderr, "Error opening pipe to gnuplot\n" );
		exit(1);
	}
	fprintf( gnuplot_fd, "set title \'Ising Monte-Carlo\'\n" );
	fprintf( gnuplot_fd, "unset colorbox\n" );
	fprintf( gnuplot_fd, "set palette define (-1 'red', 0 'white', 1 'blue')\n");
	fprintf( gnuplot_fd, "set xrange [0 : %d]; set yrange [0 : %d]; set zrange [0 : %d]\n"
		 , N1,N2,N3);
	fprintf( gnuplot_fd, "set grid x y z vertical \n");
	fprintf( gnuplot_fd, "set view 65,40\n");
	fprintf( gnuplot_fd, "set xyplane at -0.1\n");
	fprintf( gnuplot_fd, "set border 4095\n");
	fprintf( gnuplot_fd, "unset key\n" );
}

void deinit_plot()
{
	fprintf( gnuplot_fd, "exit\n" );
	pclose( gnuplot_fd );
}

void replot(bool highlight, int i, int j, int k)
{
	if(highlight) {
		fprintf( gnuplot_fd, "undefine $Highlight\n");
		fprintf( gnuplot_fd, "$Highlight << EOD\n");
		//it doesn't plot if I only use 1 point, don't understand why
		fprintf( gnuplot_fd, "%d %d %d %d\n", i, j, k, s[i][j][k]? 1 : -1);
		fprintf( gnuplot_fd, "%d %d %d %d\n", i, j, k, s[i][j][k]? 1 : -1);
		fprintf( gnuplot_fd, "EOD\n");
		fprintf( gnuplot_fd, "splot $Highlight u 1:2:3:4 with points pt 7 ps 2 palette, $charges u 1:2:3:4 with points pt 7 ps 1 palette\n");
		fflush( gnuplot_fd );
		usleep(100000);
	}

	fprintf( gnuplot_fd, "undefine $charges\n");
	fprintf( gnuplot_fd, "$charges << EOD\n");
	for (int i = 0; i < N1; ++i)
		for (int j = 0; j < N2; ++j)
			for (int k = 0; k < N3; ++k) {
				fprintf( gnuplot_fd, "%d %d %d %d\n", i, j, k, s[i][j][k]? 1 : -1);
			}
	fprintf( gnuplot_fd, "EOD\n");
	fprintf( gnuplot_fd, "splot $charges u 1:2:3:4 with points pt 7 ps 1 palette\n");
	fflush( gnuplot_fd );
}

int main()
{
	init_plot();

	for (int i = 0; i < N1; ++i)
		for (int j = 0; j < N2; ++j)
			for (int k = 0; k < N3; ++k) {
				s[i][j][k] = rand()%2;
				M += s[i][j][k]? 1 : -1;
			}
	replot(false, 0,0,0);

	for(int i = 0; i < 10000; ++i) {
		int x = rand()%N1;
		int y = rand()%N2;
		int z = rand()%N3;

		int sc = s[x][y][z]? 1 : -1;

		int sn1 = s[x? x-1 : N1-1][y][z]     ? 1 : -1;
		int sn2 = s[x < N1-1? x+1 : 0][y][z] ? 1 : -1;
		int sn3 = s[x][y? y-1 : N2-1][z]     ? 1 : -1;
		int sn4 = s[x][y < N2-1? y+1 : 0][z] ? 1 : -1;
		int sn5 = s[x][y][z? z-1 : N3-1]     ? 1 : -1;
		int sn6 = s[x][y][z < N3-1? z+1 : 0] ? 1 : -1;

		int H = sn1+sn2+sn3+sn4+sn5+sn6;
		int Hold = -H*sc;
		int Hnew = -Hold;

		if(Hnew > Hold) {
			double p = exp(-B*(Hnew - Hold));
			if ((double)rand()/RAND_MAX >= p)
				continue;
		}

		M-=s[x][y][z];
		s[x][y][z] = !s[x][y][z];
		M+=s[x][y][z];

		replot(true, x,y,z);
		//usleep( 100000 );
		std::cout << "M= " << (double) M/(N1*N2*N3) << std::endl;
	}

	//https://lwn.net/Articles/828761/
	/*
	fprintf( gnuplot_fd, "set vgrid $v size 1000\n");
	fprintf( gnuplot_fd, "set vxrange [0 : %d]; set vyrange [0 : %d]; set vzrange [0 : %d]\n"
		 , N1,N2,N3);
	fprintf( gnuplot_fd, "pot(r) = r > 0 ? 1/r : 10**6\n");
	//fprintf( gnuplot_fd, "vfill $charges using 1:2:3:(0):($4*pot(VoxelDistance))\n");
	fprintf( gnuplot_fd, "vfill $charges using 1:2:3:(0):($4)\n");
	fprintf( gnuplot_fd, "splot $v with points above -10**6 pointtype 7 pointsize 0.4 linecolor palette\n");
	fprintf( gnuplot_fd, "set style fill transparent solid 0.4\n");
	fprintf( gnuplot_fd, "splot \"++\" using (0.2):1:2:(voxel(0.2, $1, $2)) with pm3d,$charges u 1:2:3:4 with points pt 7 ps 1 palette\n");
	fflush( gnuplot_fd );
	*/

	int lazywait = 0;
	std::cout << "The end" << std::endl;
	std::cin >> lazywait;
	deinit_plot();
	return 0;
}
