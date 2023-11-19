clear;

%% Scenario 1
lambda = 10;    % jobs/s
mu1 = 50;       % jobs/s
mu2 = 5;        % jobs/s
p1 = 0.8;
p2 = 0.2;
D = p1 / mu1 + (p2) / mu2;
T = 1 / lambda;
rho = D / T;
m2 = 2*(p1/mu1^2 + p2/mu2^2);
U = rho;
R = D + (lambda*m2)/(2*(1-rho));
N = lambda*R;

fprintf("<strong>M/G/1\n</strong>");
fprintf("Utilization of the system: %g\n", U);
fprintf("Exact average response time: %g\n", R);
fprintf("Exact average number of jobs in the system: %g\n\n", N);


%% Scenario 2

% Parameters for Erlang arrivals
lambda = 240;   % jobs/s
k = 5;          % stages
T = k / lambda;
m1_a = k / lambda;
cv_a = 1 / sqrt(k);

% Parameters for Hyper-Exp departures
m1_v = p1/mu1 + p2/mu2;
m2_v = 2*(p1/mu1^2 + p2/mu2^2);
D = m1_v;
var_v = m2_v - D^2;
cv_v2 = var_v / D^2;

rho = D / (3*T);
U = rho;
theta = (D/(3*(1-rho))) / (1+(1-rho)*(2/(9*rho^3))*(1+3*rho+(9*rho^2)/2));
R = D + ((cv_a^2+cv_v2)/2)*theta;
N = R / T;

fprintf("<strong>G/G/3\n</strong>");
fprintf("Average utilization of the system: %g\n", U);
fprintf("Approximate average response time: %g\n", R);
fprintf("Approximate average number of jobs in the system: %g\n", N);