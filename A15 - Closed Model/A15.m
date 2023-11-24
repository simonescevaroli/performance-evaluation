clear;
N = 80;
Z = 40;
% in order: AppServer, StorageCtrl, DBMS, Disk1, Disk2
Sk = [50, 2, 80, 80, 120] / 1000;
P = [  0, 1,   0,   0,   0,   0;
     0.1, 0, 0.4, 0.5,   0,   0;
       0, 0,   0,   0, 0.6, 0.4;
       0, 1,   0,   0,   0,   0;
       0, 1,   0,   0,   0,   0;
       0, 1,   0,   0,   0,   0];

P0 = P;
P0(:,1) = 0;
l = [1, 0, 0, 0, 0, 0];
v = l / (eye(6) - P0);
Dk = v(:, 2:end) .* Sk;
% Mean Value Analysis technique
Qk = zeros(1,5);
Rk = zeros(1,5);
for n = 1:N
    Rk = Dk .* (1 + Qk);
    X = n / (Z + sum(Rk));
    Qk = X*Rk;
end

R = sum(Rk);
Uk = X * Dk;


fprintf("Throughput of the system: %g\n", X);
fprintf("Average system response time: %g\n", R);
fprintf("Utilization of the Application Server: %g\n", Uk(1,1));
fprintf("Utilization of the DBMS: %g\n", Uk(1,3));
fprintf("Utilization of the Disk1: %g\n", Uk(1,4));
fprintf("Utilization of the Disk2: %g\n", Uk(1,5));