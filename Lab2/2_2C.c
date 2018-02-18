extern int MAX_2(int x, int y);

int main() {
	/*int a, b, c;
	a = 1;
	b = 2;
	c = MAX_2(a,b);
	return c;*/

	int n = 5;
	int array[5] = {1,20,3,4,5};
	int max_val = 0;
	int interim_max = 0;

	int i = 0;
	for(i; i < n; i++){
		//
		max_val = MAX_2(array[i], max_val);
	}
	//printf("%d", max_val);
	return max_val;
}
