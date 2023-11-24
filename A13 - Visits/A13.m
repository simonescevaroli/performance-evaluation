clear;

%% Scenario 1
N = 10;     % users
Z = 10;     % think time in seconds
% Service of respectively: terminals, CPU, Disk, RAM
S = [10, 20/1000, 10/1000, 3/1000];
P = [  0,    1,    0,    0;
     0.1,    0,  0.3,  0.6;
       0, 0.85,    0, 0.15;
       0, 0.75, 0.25,    0];
P0 = P;
P0(:,1) = 0;
l = [1, 0, 0, 0];
v = l / (eye(4) - P0);

%Visit to the four stations
V_z = v(1,1);
V_c = v(1,2);
V_d = v(1,3);
V_r = v(1,4);
%Demand of the four stations
D = v .* S;
D_z = D(1,1);
D_c = D(1,2);
D_d = D(1,3);
D_r = D(1,4);

fprintf("<strong>First scenario\n</strong>");
fprintf("Visits to terminals: %g\n", V_z);
fprintf("Visits to CPU: %g\n", V_c);
fprintf("Visits to Disk: %g\n", V_d);
fprintf("Visits to RAM: %g\n", V_r);
fprintf("Demand of terminals: %g\n", D_z);
fprintf("Demand of CPU: %g\n", D_c);
fprintf("Demand of Disk: %g\n", D_d);
fprintf("Demand of RAM: %g\n\n", D_r);



%clear;
%% Scenario 2
lambdaIn = [0.3, 0, 0];
lambda0 = sum(lambdaIn);
% Service of respectively: CPU, Disk, RAM
S = [20/1000, 10/1000, 3/1000];
P = [   0,  0.3,  0.6;
      0.8,    0, 0.15;
     0.75, 0.25,    0];
l = lambdaIn/lambda0;
v = l / (eye(3) - P);
arrivals = lambda0*v;

%Visit to the three stations
V_c = v(1,1);
V_d = v(1,2);
V_r = v(1,3);
%Demand of the three stations
D = v .* S;
D_c = D(1,1);
D_d = D(1,2);
D_r = D(1,3);
%Throughput of the three stations
X = lambdaIn(1,1) * v;
X_c = X(1,1);
X_d = X(1,2);
X_r = X(1,3);

fprintf("<strong>Second scenario\n</strong>");
fprintf("Visits to CPU: %g\n", V_c);
fprintf("Visits to Disk: %g\n", V_d);
fprintf("Visits to RAM: %g\n", V_r);
fprintf("Demand of CPU: %g\n", D_c);
fprintf("Demand of Disk: %g\n", D_d);
fprintf("Demand of RAM: %g\n", D_r);
fprintf("Throughput of CPU: %g\n", X_c);
fprintf("Throughput of Disk: %g\n", X_d);
fprintf("Throughput of RAM: %g\n", X_r);