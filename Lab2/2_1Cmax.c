int main() {
	//int n = 5;
	int a[5] = {1,20,3,4,5};
	int max_val = 0;
	//todo
	int i = 0;
	int n = sizeof(a)/sizeof(a[0]);
	for(i; i<n; i++){
		if(a[i] > max_val){
			max_val = a[i];
		}
	}
	//printf("%d", max_val);
	return max_val;
}
