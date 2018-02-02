/*==========================================================
 * in this programming I convert array H to 3 parts
 * for 1 2 3 4 5 6 7 8 9 10, L=3; The 3 parts are 
 *1 2 3| 4 5 6 7 |8 9 10
 *the first part you have to add some 0 before,
 *the second part all you add are numbers
 *the third part you will add some zero after
 *than I add all of this part
 *last I configure average value
 *========================================================*/
/************ read me ***********************8
 * L=3;
 * H=1:10;
 * mexExamTemp(H,L)
 */
#include "mex.h"

/* The computational routine */
void oneDimFilter(double *H, double *Hp,double L,mwSize m){
    //if (n%2 == 0)
    mwSize LL=L-1;      // matlab to c
    mwSize devider,n,i,j=0; 
    devider=2*L+1;   
    for(i=0;i<=LL;i++){
        n=i+L;    
        Hp[i]=0;
        for (j=0;j<=n;j++){
            Hp[i]=Hp[i]+H[j];
        }
    }
    for(i;i>LL&&i<(m-L);i++){
        Hp[i]=0;
        for(j=i-L;j<=i+L;j++){
            Hp[i]=Hp[i]+H[j];
        }
    }
    for(i;i>=(m-L)&&i<m;i++){
        Hp[i]=0;
        for(j=i-L;j<m;j++){
            Hp[i]=Hp[i]+H[j];
        }
    }
    for (i=0;i<m;i++){
    Hp[i]=Hp[i]/devider;
    }   
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{   double *inMatrix;   
    size_t mcols;   
    int Linput;
    double *outMatrix;

    inMatrix = mxGetPr(prhs[0]);
    Linput = mxGetScalar(prhs[1]);
    mcols = mxGetN(prhs[0]);
    plhs[0] = mxCreateDoubleMatrix(1,mcols,mxREAL);
    outMatrix = mxGetPr(plhs[0]);
    oneDimFilter(inMatrix,outMatrix,Linput,(mwSize)mcols);
    
/* Some functions that you can use.
mxGetPr();
mxGetN();
mxGetM();
mxGetScalar();
mxCreateDoubleMatrix();
mxGetPr();
you can print out to matlab prompt using "mexPrintf" function. It is used in the same way as printf in C/
 
*/
    
    

}
