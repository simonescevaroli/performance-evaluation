clear;
% in order: SelfCheck, AppServer, Storage, DBMS
S = [2, 30/1000, 100/1000, 80/1000];
lambdaIn = [3, 2, 0, 0];
lambda0 = sum(lambdaIn);
P = [0, 0.8,   0,   0;
     0,   0, 0.3, 0.5;
     0,   1,   0,   0;
     0,   1,   0,   0];
l = lambdaIn/lambda0;
v = l / (eye(4) - P);
arrivals = lambda0*v;


D = v .* S;
X = lambda0;
U = X * D;
U(1,1) = 0; % since it's a terminal station, U -> 0
Residence_t = [D(1,1), D(1,2)/(1-U(1,2)), D(1,3)/(1-U(1,3)), D(1,4)/(1-U(1,4))];
R = sum(Residence_t);
N = X * R;


fprintf("Throughput of the system: %g\n", X);
fprintf("Average number of jobs in the system: %g\n", N);
fprintf("Average system response time: %g\n", R);