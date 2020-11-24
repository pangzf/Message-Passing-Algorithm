/*======================================================*/
/* Author: Chao-wang Huang                                                                  */
/* Date: Tuesday, October 14, 2008                                                      */
/* A Bit-based Message Passing Algorithm for ICI Channel is simulated */
/*======================================================*/

#include "stdafx.h"
#include <math.h>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctime>
#include <conio.h>
#include <limits.h>
#include <float.h>
#include <cstdlib>
#include <iostream>
using namespace std;
#include <fstream>
#include <cstdio>
#include <assert.h>

void AWGN_noise(float, double, double *);
int Error_count(int, int);
void JakesFading(double, double, double, int, double *, double);
void Multipath_fade_pattern(double ***, int);
//void dfour1(double *, unsigned long, int);

//#define SWAP(a,b) tempr=(a);(a)=(b);(b)=tempr
#define Pi 		3.14159265358979
#define num_packet 10						// number of packets simulated
const int Mc = 2;									// modulation order (2 for QPSK)
const int Iteration = 2;
const int N_fft =  1024;
const int CP_length = N_fft/8;				// Length of Cyclic Prefix
const double sample_rate = 11.2e6;		/* Sampling Frequency */
/* power Delay Profile of ITU Vehicular A Channel */
const int path_num = 6;
const int path_delay[6] = {0,3,8,12,19,28};	// Delay (sample) {0,310,710,1090,1730,2510} (ns)
const double path_gain[6] = {0.485,0.3853,0.0611,0.0485,0.0153,0.0049};	// Power Gain (linear scale)
const int delay_spread = 28;				// Maximum path delay (samples)
const double vc = 350.0;						/* speed of vehicle in km/hr */
const double C = 3.0e8;						/* light speed */
const double fc = 2.5e9;						/* carrier frequency */
const double OFDM_sym_duration = 91.43e-6;		/* OFDMA Symbol Duration without Cyclic Prefix */
const double Doppler = (vc*1000.0/3600.0)/(C/fc);  // Maximum Doppler frequency (Hz)
const int D = 1;										// Total ICI Subcarriers = 2D
const int ICI = 2*D+1;
const int B = Mc*ICI;
const int X = (int)pow(2.0,B-1.0);
double *ts, *theta_n;
int *delay;

int main(void)
{
	time_t  ti, start, end;
	int d, i, k, l, m, n, p, s, t, x, z, *data, *data_bit, **Ak, *err_count;
	double snr, Eb_No, noise_pwr, noise[2], Y[2], **Yk, *err_rate, Ps;
	double P, sum, RQ_tmp[2], pdf, ****R_pn, ****Q_np, *sym_I, *sym_Q;
	double ***Out, *gain, ***fade, ***F_l, **H_I, **H_Q;
	FILE *ber, *records;

	start = time(NULL);
	printf("BER Performance of Bit-based Message Passing in SISO ICI Channel\n");
	printf("Maximum number of bits of simulation = %d\n\n", Mc*num_packet*N_fft);
	printf("This program is running. Don't close, please!\n\n");

	fopen_s(&records, "Record_Bit-based_Message_Passing.log", "a");
	fprintf(records, "BER Performance of Bit-based Message Passing in SISO ICI Channel\n");
	fprintf(records, "Maximum number of bits of simulation = %d\n\n", Mc*num_packet*N_fft);
	fprintf(records, "Eb/No     BER\n");
	fflush(records);
	
	data_bit = new int[N_fft*Mc];
	err_count = new int[Iteration];
	err_rate = new double[Iteration];
	ts = new double[path_num];
	theta_n = new double[path_num];
	gain = new double[path_num];
	delay = new int[path_num];
	sym_I = new double[N_fft];
	sym_Q = new double[N_fft];
	fade = new double**[path_num];
	for(l=0; l<path_num; l++)
		fade[l] = new double*[N_fft+CP_length];
	for(l=0; l<path_num; l++)
		for(t=0; t<N_fft+CP_length; t++)
			fade[l][t] = new double[2];
   	Yk = new double*[N_fft];
	for(l=0; l<N_fft; l++)
		Yk[l] = new double[2];
	F_l = new double**[path_num];
	for(i=0; i<path_num; i++)
		F_l[i] = new double*[N_fft];
	for(i=0; i<path_num; i++)
		for(l=0; l<N_fft; l++)
			F_l[i][l] = new double[2];
	H_I = new double*[N_fft];
	for(l=0; l<N_fft; l++)
		H_I[l] = new double[N_fft];
	H_Q = new double*[N_fft];
	for(l=0; l<N_fft; l++)
		H_Q[l] = new double[N_fft];
   	Q_np = new double***[N_fft];
	for(t=0; t<N_fft; t++)
   		Q_np[t] = new double**[N_fft];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
   			Q_np[t][d] = new double*[Mc];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
			for(m=0; m<Mc; m++)
   				Q_np[t][d][m] = new double[2];
   	R_pn = new double***[N_fft];
	for(t=0; t<N_fft; t++)
   		R_pn[t] = new double**[N_fft];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
   			R_pn[t][d] = new double*[Mc];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
			for(m=0; m<Mc; m++)
   				R_pn[t][d][m] = new double[2];
	data = new int[Mc*N_fft];
	Ak = new int*[N_fft];
	for(t=0; t<N_fft; t++)
		Ak[t] = new int[Mc];
   	Out = new double**[N_fft];
	for(t=0; t<N_fft; t++)
   		Out[t] = new double*[Mc];
	for(t=0; t<N_fft; t++)
		for(m=0; m<Mc; m++)
   			Out[t][m] = new double[2];
							
	// Channel Weighting Gain and Channel path delay
	for(i=0; i<path_num; i++)
	{
		delay[i] = path_delay[i];
		gain[i] = sqrt(path_gain[i]);
	}

	srand((unsigned) time(&ti));

/*======================*/
/* main simulation loop            */
/*======================*/
	fopen_s(&ber, "BER_Bit-based_Message_Passing.log", "w");
	for(snr=20; snr<=20; snr+=4)
	{
   		for(s=0; s<Iteration; s++)
   			err_count[s] = 0;

   		// noise power calculation
		Eb_No = (double)snr;
		Ps = 1;
		//noise_pwr = 0.5*Ps/((float)N_fft*pow(10.0, Eb_No/10.0));	// QPSK, Nyquist filter assumption (Time Domain)
		noise_pwr = 0.5*Ps/((float)pow(10.0, Eb_No/10.0));	// QPSK, Nyquist filter assumption (Freq. Domain)
		printf("Eb_No = %f\n", Eb_No);

		// Initial time of Rayleigh fading pattern
		for(l=0; l<path_num; l++)
		{
			ts[l] = 100.0 + l*100.0;
			theta_n[l] = 2.0*Pi*((double)rand()/(double)RAND_MAX);  // random phase
		}

		p = 0;
		do
		{
			for(l=0; l<N_fft; l++)
				for(m=0; m<Mc; m++)
					// Generate random information bit stream
					if(rand()/(float)RAND_MAX>=0.5)
						data_bit[l*Mc+m] = 1;
					else
						data_bit[l*Mc+m] = 0;

			for(l=0; l<N_fft; l++)
			{
				// QPSK Mapping
				sym_I[l] = (2*data_bit[l*Mc]-1)/sqrt(2.0);
         		sym_Q[l] = (2*data_bit[l*Mc+1]-1)/sqrt(2.0);	
			}

			// Multi-path Rayleigh fading pattern
			//for(l=0; l<path_num; l++)
			//	theta_n[l] = 2.0*Pi*((double)rand()/(double)RAND_MAX);  // random phase
			Multipath_fade_pattern(fade, path_num);

			// Channel Frequency Response
			for(l=0; l<path_num; l++)
				for(k=0; k<N_fft; k++)
				{
					F_l[l][k][0] = F_l[l][k][1] = 0.0;
					for(t=0; t<N_fft; t++)
					{
						F_l[l][k][0] += gain[l]*fade[l][t+CP_length-delay[l]][0] * cos(2*Pi*t*k/(float)N_fft) + gain[l]*fade[l][t+CP_length-delay[l]][1] * sin(2*Pi*t*k/(float)N_fft);
						F_l[l][k][1] += gain[l]*fade[l][t+CP_length-delay[l]][1] * cos(2*Pi*t*k/(float)N_fft) - gain[l]*fade[l][t+CP_length-delay[l]][0] * sin(2*Pi*t*k/(float)N_fft);
					}
				}

			// Channel Frequency Response & ICI Channel Coefficients
			for(t=0; t<N_fft; t++)
				for(d=0; d<N_fft; d++)
				{
					H_I[t][d] = H_Q[t][d] = 0.0;
					for(l=0; l<path_num; l++)
					{
						H_I[t][d] += F_l[l][d][0] * cos(2*Pi*delay[l]*(t-d)/(float)N_fft) + F_l[l][d][1] * sin(2*Pi*delay[l]*(t-d)/(float)N_fft);
						H_Q[t][d] += F_l[l][d][1] * cos(2*Pi*delay[l]*(t-d)/(float)N_fft) - F_l[l][d][0] * sin(2*Pi*delay[l]*(t-d)/(float)N_fft);
					}

					H_I[t][d] /= (float)N_fft;
					H_Q[t][d] /= (float)N_fft;
				}

			// Freq. Domain Transmission
			for(t=0; t<N_fft; t++)
			{
				Yk[t][0] = Yk[t][1] = 0.0;
				for(d=0; d<N_fft; d++)
				{
					Yk[t][0] += (sym_I[(N_fft+t-d)%N_fft] * H_I[t][d] - sym_Q[(N_fft+t-d)%N_fft] * H_Q[t][d]);
					Yk[t][1] += (sym_I[(N_fft+t-d)%N_fft] * H_Q[t][d] + sym_Q[(N_fft+t-d)%N_fft] * H_I[t][d]);
				}

				// AWGN noise
				AWGN_noise(0.0, noise_pwr, &noise[0]);
		  	   	Yk[t][0] += noise[0];
		       	Yk[t][1] += noise[1];
			}

/*==================================================*/
/*  B i t - b a s e d    M e s s a g e    P a s s i n g    A l g o r i t h m  */
/*==================================================*/

			// Initilization of extrinsic(intrinsic) probability
			for(m=0; m<Mc; m++)
				for(t=0; t<N_fft; t++)
					for(d=0; d<N_fft; d++)
     					for(k=0; k<2; k++)
						{
   							Q_np[t][d][m][k] = 0.5;
							R_pn[t][d][m][k] = 0.5;
						}

			for(s=0; s<Iteration; s++)
			{
				// Extrinsic information of function nodes
				for(t=0; t<N_fft; t++)
					for(d=0; d<N_fft; d++)
						if(d <= D || d >= N_fft-D)
							for(m=0; m<Mc; m++)
							{
								for(k=0; k<2; k++)		// Probability of 1 and 0
								{
									RQ_tmp[k] = 0.0;
									for(x=0; x<X; x++)
   									{
               							z = 0;
										data[((N_fft+t-d)%N_fft)*Mc+m] = k;
										for(l=0; l<N_fft; l++)
											if(l <= D || l >= N_fft-D)
												for(n=0; n<Mc; n++)
		           	         						if(((N_fft+t-l)%N_fft)*Mc+n != ((N_fft+t-d)%N_fft)*Mc+m)
				   									{
						  	      						data[((N_fft+t-l)%N_fft)*Mc+n] = (x>>z) & 1;
			                     						z++;
					                				}
										
										for(l=0; l<N_fft; l++)
											if(l <= D || l >= N_fft-D)
											{
         	            						sym_I[(N_fft+t-l)%N_fft] = (2*data[((N_fft+t-l)%N_fft)*Mc]-1)/sqrt(2.0);
				       							sym_Q[(N_fft+t-l)%N_fft] = (2*data[((N_fft+t-l)%N_fft)*Mc+1]-1)/sqrt(2.0);
											}

										Y[0] = Y[1] = 0.0;
										for(l=0; l<N_fft; l++)
											if(l <= D || l >= N_fft-D)
											{
												Y[0] += (sym_I[(N_fft+t-l)%N_fft] * H_I[t][l] - sym_Q[(N_fft+t-l)%N_fft] * H_Q[t][l]);
												Y[1] += (sym_I[(N_fft+t-l)%N_fft] * H_Q[t][l] + sym_Q[(N_fft+t-l)%N_fft] * H_I[t][l]);
											}

                     					P = 1.0;
				                   		for(l=0; l<N_fft; l++)
											if(l <= D || l >= N_fft-D)
												for(n=0; n<Mc; n++)
								     				if(((N_fft+t-l)%N_fft)*Mc+n != ((N_fft+t-d)%N_fft)*Mc+m)
														P *= Q_np[(N_fft+t-l)%N_fft][t][n][data[((N_fft+t-l)%N_fft)*Mc+n]];

										sum = 0.0;
										for(z=0; z<2; z++)
                        					sum += pow(Yk[t][z]-Y[z],2.0);

										pdf = exp(-sum/noise_pwr)/(Pi*noise_pwr);
                     					RQ_tmp[k] += pdf * P;
                  					}
								}

								R_pn[t][((N_fft+t-d)%N_fft)][m][1] = RQ_tmp[1] / (RQ_tmp[0] + RQ_tmp[1]);
								R_pn[t][((N_fft+t-d)%N_fft)][m][0] = RQ_tmp[0] / (RQ_tmp[0] + RQ_tmp[1]);
							}
 	
				// Extrinsic information of bit nodes
				for(t=0; t<N_fft; t++)
					for(m=0; m<Mc; m++)
						for(d=0; d<N_fft; d++)
							if(d <= D || d >= N_fft-D)
							{
								RQ_tmp[0] = RQ_tmp[1] = 1.0;
           						for(l=0; l<N_fft; l++)
									if(l <= D || l >= N_fft-D)
           								if(l != d)
										{
		                 					RQ_tmp[1] *= R_pn[((N_fft+t-l)%N_fft)][t][m][1];
											RQ_tmp[0] *= R_pn[((N_fft+t-l)%N_fft)][t][m][0];
										}
												
								Q_np[t][((N_fft+t-d)%N_fft)][m][1] = RQ_tmp[1] / (RQ_tmp[1] + RQ_tmp[0]);
								Q_np[t][((N_fft+t-d)%N_fft)][m][0] = RQ_tmp[0] / (RQ_tmp[1] + RQ_tmp[0]);
							}

				// Bit Nodes Decision Output
				for(t=0; t<N_fft; t++)
					for(m=0; m<Mc; m++)
					{
						RQ_tmp[0] = RQ_tmp[1] = 1.0;
						for(d=0; d<N_fft; d++)
							if(d <= D || d>= N_fft-D)
							{
								RQ_tmp[1] *= R_pn[((N_fft+t-d)%N_fft)][t][m][1];
								RQ_tmp[0] *= R_pn[((N_fft+t-d)%N_fft)][t][m][0];
							}

						Out[t][m][1] = RQ_tmp[1] / (RQ_tmp[1] + RQ_tmp[0]);
						Out[t][m][0] = RQ_tmp[0] / (RQ_tmp[1] + RQ_tmp[0]);

						if(Out[t][m][1] >= Out[t][m][0])
           					Ak[t][m] = 1;
       					else
	           				Ak[t][m] = 0;

            			err_count[s] += Error_count(data_bit[t*Mc+m], Ak[t][m]);
					}
			}
	
			p++;
		} while(err_count[Iteration-1] <= 1000 && p < num_packet);

		// Statistics and records
		cout << "Error Rate = ";
		for(s=0; s<Iteration; s++)
		{
      		err_rate[s] = err_count[s] / (double)(Mc*p*N_fft);
      		printf("%e, ", err_rate[s]);
		}
		cout << endl;

		fprintf(ber, "%f ", Eb_No);
		fprintf(records, "%f ", Eb_No);
		for(s=0; s<Iteration; s++)
		{
			fprintf(ber, "%e ", err_rate[s]);
			fprintf(records, "%e %d ", err_rate[s], err_count[s]);
		}
		fprintf(ber, "\n");
		fprintf(records, "\n");
		fflush(records);
		fflush(ber);
	}
	
	delete data_bit;
	delete err_count;
	delete err_rate;
	delete ts;
	delete theta_n;
	delete gain;
	delete delay;
	delete sym_I;
	delete sym_Q;
	for(l=0; l<path_num; l++)
		for(t=0; t<N_fft+CP_length; t++)
			delete fade[l][t];
	for(l=0; l<path_num; l++)
		delete fade[l];
	delete fade;
	for(i=0; i<path_num; i++)
		for(l=0; l<N_fft; l++)
			delete F_l[i][l];
	for(i=0; i<path_num; i++)
		delete F_l[i];
	delete F_l;
	delete data;
	for(t=0; t<N_fft; t++)
		delete Ak[t];
	delete Ak;
	for(t=0; t<N_fft; t++)
		for(m=0; m<Mc; m++)
   			delete Out[t][m];
	for(t=0; t<N_fft; t++)
   		delete Out[t];
	delete Out;
	for(l=0; l<N_fft; l++)
		delete Yk[l];
	delete Yk;
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
			for(m=0; m<Mc; m++)
   				delete Q_np[t][d][m];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
   			delete Q_np[t][d];
	for(t=0; t<N_fft; t++)
   		delete Q_np[t];
	delete Q_np;
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
			for(m=0; m<Mc; m++)
   				delete R_pn[t][d][m];
	for(t=0; t<N_fft; t++)
		for(d=0; d<N_fft; d++)
			delete R_pn[t][d];
	for(t=0; t<N_fft; t++)
   		delete R_pn[t];
	delete R_pn;
	for(l=0; l<N_fft; l++)
		delete H_I[l];
	delete H_I;
	for(l=0; l<N_fft; l++)
		delete H_Q[l];
	delete H_Q;

	end = time(NULL);
	printf("Total elapsed time: %.0f(sec)\n", difftime(end,start));
	fprintf(records, "\nTotal elapsed time: %.0f(sec)\n\n", difftime(end,start));
	fclose(ber);
	fclose(records);
	printf("This program is ended. Press any key to continue.\n");
	getchar();

	return 0;
}

void AWGN_noise(float mu, double variance, double *noise)
{
//	const  float Pi = 3.14159265358979;
   double u1, u2;
   do
   {
   	u1 = (double)rand()/(double)RAND_MAX;
      u2 = (double)rand()/(double)RAND_MAX;
   }
   while(u1 == 0.0 || u2 == 0.0);

   *(noise+0) = (sqrt(-2.0*log(u1))*cos(2*Pi*u2))*sqrt(variance/2.0)+mu/sqrt(2.0);
   *(noise+1) = (sqrt(-2.0*log(u1))*sin(2*Pi*u2))*sqrt(variance/2.0)+mu/sqrt(2.0);
}

int Error_count(int x, int y)
{
	if(x == y)
   	return 0;
   else
   	return 1;
}

void JakesFading(double f_c/*Hz*/, double v/*m/s*/, double t/*s*/, int type, double *fade, double theta_n)
{
	//const double C = 3.0e8;     // (m/s)
   //const float Pi = 3.14159265358979;
   int n, Np, N_o = 32;
   double lamda, w_m, beta_n, w_n, alpha, T_c2, T_s2/*, theta_n*/;

   lamda = C/f_c;     // wave length (meter)
   w_m = 2.0*Pi*v/lamda;    // maximum Doppler frequency
   Np = 2*(2*N_o+1);

   switch(type)
   {
   	case 1:
   		alpha = 0.0;
         T_c2 = (double)N_o;
         T_s2 = (double)N_o + 1.0;
         break;
      case 2:
      	alpha = 0.0;
         T_c2 = (double)N_o + 1.0;
         T_s2 = (double)N_o;
         break;
      case 3:
      	alpha = Pi/4.0;
         T_c2 = (double)N_o + 0.5;
         T_s2 = (double)N_o + 0.5;
         break;
      default:
      	printf("\nInvalid type selection for Jake's fading channel model.\n");
         break;
   }

   if(v < 0.0)
	{
		printf("Warning!! The vehicle speed is invalid.\n");
		cout << "Vehicle speed: " << v << "km/h" << endl;
		getchar();
   		//*(fade+0) = 1.0;
		//*(fade+1) = 0.0;
   }
   else
   {
   	*(fade+0) = sqrt(1.0/T_c2)*cos(alpha)*cos(w_m*t);
      *(fade+1) = sqrt(1.0/T_s2)*sin(alpha)*cos(w_m*t);

      for(n = 1; n <= N_o; n++)
      {
      	switch(type)
         {
         	case 1:
            	beta_n = (double)n*Pi/((double)N_o+1.0);
               break;
            case 2:
            	beta_n = (double)n*Pi/(double)N_o;
               break;
            case 3:
            	beta_n = (double)n*Pi/(double)N_o;
               break;
         	default:
            	break;
         }
         w_n = w_m*cos(2.0*Pi*(double)n/(double)Np);
            //theta_n = 2.0*Pi*((double)rand()/(double)RAND_MAX);  // random phase
			//theta_n = 0.0;
         *(fade+0) += sqrt(2.0/T_c2)*cos(beta_n)*cos(w_n*t+theta_n);
         *(fade+1) += sqrt(2.0/T_s2)*sin(beta_n)*cos(w_n*t+theta_n);
		}
	}
}

void Multipath_fade_pattern(double ***fade, int path_num)
{
	int l, t;
	double gain[2];

	for(l=0; l<path_num; l++)
		for(t=0; t<N_fft+CP_length; t++)
		{
			JakesFading(fc, vc*1000/3600.0, ts[l], 2, &gain[0], theta_n[l]);
			ts[l] += OFDM_sym_duration / (float)N_fft;
			fade[l][t][0] = gain[0];
			fade[l][t][1] = gain[1];
		}
}
/*
void dfour1(double data[],unsigned long nn,int isign)
//double data[];
//unsigned long nn;
//int isign;
{
	unsigned long n,mmax,m,j,istep,i;
   double wtemp,wr,wpr,wpi,wi,theta;
   double tempr,tempi;

   n=nn << 1;
   j=1;
   for (i=1;i<n;i+=2)
   {
   	if (j > i)
      {
      	SWAP(data[j],data[i]);
         SWAP(data[j+1],data[i+1]);
      }
      m=n >> 1;
      while (m >= 2 && j > m)
      {
      	j -= m;
         m >>= 1;
      }
      j += m;
   }
   mmax=2;
   while (n > mmax)
   {
   	istep=mmax << 1;
      theta=isign*(6.28318530717959/mmax);
      wtemp=sin(0.5*theta);
      wpr = -2.0*wtemp*wtemp;
      wpi=sin(theta);
      wr=1.0;
      wi=0.0;
      for (m=1;m<mmax;m+=2)
      {
      	for (i=m;i<=n;i+=istep)
         {
         	j=i+mmax;
            tempr=wr*data[j]-wi*data[j+1];
            tempi=wr*data[j+1]+wi*data[j];
            data[j]=data[i]-tempr;
            data[j+1]=data[i+1]-tempi;
            data[i] += tempr;
            data[i+1] += tempi;
         }
         wr=(wtemp=wr)*wpr-wi*wpi+wr;
         wi=wi*wpr+wtemp*wpi+wi;
      }
      mmax=istep;
   }
}
#undef SWAP
*/