#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <cmath>
#include <chrono>
using namespace std;

double RandomDraw() {
    return double(rand()) / double(RAND_MAX);
}

int main() {
    using namespace std::chrono;
    int N_samples[7] = { 10, 100, 500, 1000, 5000, 10000, 50000};
    int N_i;
    double x, y;
    double pi_estimate;
    double e_rel;
    const double pi = 3.14159265359;

    srand(time(0));
    for (int i = 0; i < 7; i++) {
        high_resolution_clock::time_point start = high_resolution_clock::now();
        N_i = 0;
        for (int n = 0; n < N_samples[i]; n++) {
            x = RandomDraw();
            y = RandomDraw();
            if (x*x + y*y <= 1) N_i++;
        }
        pi_estimate = 4*double(N_i) / double(N_samples[i]);
        e_rel = fabs(pi_estimate - pi)/pi;
        high_resolution_clock::time_point finish = high_resolution_clock::now();
        duration<double> elapsed = duration_cast<duration<double>>(finish - start);
        printf("%5i %5i %5i %10f %8.5f %10g\n", N_samples[i], N_i, N_samples[i] - N_i, pi_estimate, e_rel, elapsed.count());
    }

    return 0;
}
