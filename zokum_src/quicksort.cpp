
// modified version of code from http://www.cprogramto.com/c-program-quick-sort/

//quick Sort function to Sort Integer array list

/*
#include "level.hpp"
#include "ZenNode.hpp"
#include "blockmap.hpp"
#include "console.hpp"
*/

// #include "bits/stdc++.h"

using namespace std;
int compare( const void *aa, const void  *bb)
{
	int *a=(int *)aa;
	int *b=(int *)bb;
	if (a[0]<b[0])
		return -1;
	else if (a[0]==b[0]) 
		return 0;
	else  
		return 1;

}
/*
void insertionSort(int array[], int array2[], int firstIndex, int lastIndex) {
	int n, c, d, t, t2;

	for (c = 1 ; c <= n - 1; c++) {
		d = c;

		while ( d > 0 && array[d] < array[d-1]) {
			t          = array[d];
			array[d]   = array[d-1];
			array[d-1] = t;

			t2          = array2[d];
			array2[d]   = array[d-1];
			array2[d-1] = t2;


			d--;
		}
	}
}

void quickSort(int array[], int array2[], int firstIndex, int lastIndex) {
	//declaring index variables
	int pivotIndex, temp, index1, index2;

	int temp2;

	if(firstIndex < lastIndex) {
		//assigning first element index as pivot element. This should be ok in doom.
		pivotIndex = firstIndex;
		index1 = firstIndex;
		index2 = lastIndex;

		//Sorting in Ascending order with quick sort
		while(index1 < index2) {
			while(array[index1] <= array[pivotIndex] && index1 < lastIndex) {
				index1++;
			}
			while(array[index2]>array[pivotIndex]) 	{
				index2--;
			}

			if(index1<index2) {
				//Swapping operation
				temp = array[index1];
				array[index1] = array[index2];
				array[index2] = temp;

				// we also swap the other array
				temp2 = array2[index1];
				array2[index1] = array2[index2];
				array2[index2] = temp2;
			}
		}
		//At the end of first iteration, swap pivot element with index2 element
		temp = array[pivotIndex];
		array[pivotIndex] = array[index2];
		array[index2] = temp;

		temp2 = array2[pivotIndex];
		array2[pivotIndex] = array2[index2];
		array2[index2] = temp2;

		//Recursive call for quick sort, with partiontioning
		if ((index2 - firstIndex) < 10) {
			insertionSort(array, array2, firstIndex, index2-1);
		} else {
			quickSort(array, array2, firstIndex, index2-1);
		}

		if ((lastIndex - index2 ) < 10) {
			insertionSort(array, array2, firstIndex, index2-1);
		} else {
			quickSort(array, array2, index2+1, lastIndex);
		}
	}
}
*/

/*
   int main()
   {
//Declaring variables
int array[100],n,i;

//Number of elements in array form user input
printf("Enter the number of element you want to Sort : ");
scanf("%d",&n);

//code to ask to enter elements from user equal to n
printf("Enter Elements in the list : ");
for(i = 0; i < n; i++)
{
scanf("%d",&array[i]);
}

//calling quickSort function defined above
quicksort(array,0,n-1);

//print sorted array
printf("Sorted elements: ");
for(i=0;i<n;i++)
printf(" %d",array[i]);

getch();
return 0;
}
*/
