#include <stdio.h>
#include "fonctions.h"

int main() {

	int r1, r2, r3, r4;

	r1 = addition(5, 5);
	r2 = soustraction(10, 5);
	r3 = division (10, 2);
	r4 = multiplication(2, 5);

	printf("\n\nRésultats :\n %i\n %i\n %i\n %i\n", r1, r2, r3, r4);

	return 0;

}
