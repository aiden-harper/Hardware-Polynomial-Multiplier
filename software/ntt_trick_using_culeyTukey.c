#include <stdio.h>

#define MOD 17
#define ROOT 3
#define N 8

// Fast exponentiation (base^exp % mod)
int mod_pow(int base, int exp, int mod) {
    int result = 1;
    while (exp > 0) {
        if (exp % 2 == 1) {
            result = (result * base) % mod;
        }
        base = (base * base) % mod;
        exp /= 2;
    }
    return result;
}

// Compute Twiddle Factors
void compute_twiddle_factors(int *twiddle, int n, int root, int mod) {
    int base = mod_pow(root, (mod - 1) / n, mod);
    twiddle[0] = 1;
    for (int i = 1; i < n; i++) {
        twiddle[i] = (twiddle[i - 1] * base) % mod;
    }
}

// Bit reversal
void bit_reverse(int *a, int n) {
    int i, j = 0;
    for (i = 1; i < n; i++) {
        int bit = n >> 1;
        while (j & bit) {
            j ^= bit;
            bit >>= 1;
        }
        j ^= bit;
        if (i < j) {
            int temp = a[i];
            a[i] = a[j];
            a[j] = temp;
        }
    }
}

// Cooley-Tukey butterfly transformation
void ntt(int *a, int n, int *twiddle, int mod) {
    bit_reverse(a, n); // Bit reversal
    for (int len = 2; len <= n; len *= 2) {
        int step = n / len;
        for (int i = 0; i < n; i += len) {
            for (int j = 0; j < len / 2; j++) {
                int u = a[i + j];
                int v = (a[i + j + len / 2] * twiddle[j * step]) % mod;
                a[i + j] = (u + v) % mod;
                a[i + j + len / 2] = (u - v + mod) % mod;
            }
        }
    }
}

// Inverse transformation
void intt(int *a, int n, int *inv_twiddle, int mod) {
    bit_reverse(a, n); // Bit reversal
    for (int len = 2; len <= n; len *= 2) {
        int step = n / len;
        for (int i = 0; i < n; i += len) {
            for (int j = 0; j < len / 2; j++) {
                int u = a[i + j];
                int v = (a[i + j + len / 2] * inv_twiddle[j * step]) % mod;
                a[i + j] = (u + v) % mod;
                a[i + j + len / 2] = (u - v + mod) % mod;
            }
        }
    }
    int n_inv = mod_pow(n, mod - 2, mod); // Inverse of n
    for (int i = 0; i < n; i++) {
        a[i] = (a[i] * n_inv) % mod;
    }
}

// Pointwise multiplication for polynomial multiplication
void pointwise_multiply(int *a, int *b, int *result, int n, int mod) {
    for (int i = 0; i < n; i++) {
        result[i] = (a[i] * b[i]) % mod;
    }
}

int main() {
    int f[N] = {1, 2, 3, 4, 5, 6, 7, 8};
    int g[N] = {1, 2, 3, 4, 5, 6, 7, 8};
    int twiddle[N], inv_twiddle[N];
    int ntt_f[N], ntt_g[N], ntt_result[N];
    int result[N];

    // Compute Twiddle Factors
    compute_twiddle_factors(twiddle, N, ROOT, MOD);
    compute_twiddle_factors(inv_twiddle, N, mod_pow(ROOT, MOD - 2, MOD), MOD);

    printf("Twiddle Factors:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", twiddle[i]);
    }
    printf("\n");

    // Forward Transform
    for (int i = 0; i < N; i++) ntt_f[i] = f[i];
    ntt(ntt_f, N, twiddle, MOD);
    printf("NTT(f):\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", ntt_f[i]);
    }
    printf("\n");

    // Inverse Transform
    intt(ntt_f, N, inv_twiddle, MOD);
    printf("INTT(NTT(f)):\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", ntt_f[i]);
    }
    printf("\n");

    // Polynomial Multiplication
    for (int i = 0; i < N; i++) ntt_g[i] = g[i];
    ntt(ntt_g, N, twiddle, MOD);
    pointwise_multiply(ntt_f, ntt_g, ntt_result, N, MOD);
    intt(ntt_result, N, inv_twiddle, MOD);

    printf("Polynomial Multiplication Result:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", ntt_result[i]);
    }
    printf("\n");

    return 0;
}
