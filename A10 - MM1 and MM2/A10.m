clear;

%% Scenario 1
lambda = 40;    %job/s
D = 16 / 1000;    %in seconds
mu = 1 / D;
rho = lambda / mu;
utilization = rho;
P1Job = (1 - rho) * rho;
PLess10 = 1 - rho^(9+1);
AvgQueueLen = (rho^2) / (1-rho);
AvgRespTime = D / (1-rho);
PRespGrt05 = exp(-0.5/AvgRespTime);
Perc90 = -log(1-90/100)*AvgRespTime;


fprintf("<strong>M/M/1</strong>\n");
fprintf("Utilization: %g\n", utilization);
fprintf("Probability of having exactly 1 job in the system: %g\n", P1Job);
fprintf("Probability of having < 10 jobs in the system: %g\n", PLess10);
fprintf("Average queue length: %g\n", AvgQueueLen);
fprintf("Average response time: %g\n", AvgRespTime);
fprintf("Probability that the response time > 0.5 s: %g\n", PRespGrt05);
fprintf("90 percentile of the response time distribution: %g\n\n", Perc90);

%% Scenario 2
lambda = 90;    %job/s
D = 16 / 1000;    %in seconds
rho = (lambda * D) / 2;
tot_utilization = lambda * D;
avg_utilization = tot_utilization / 2;
pi0 = (1-rho) /(1+rho);
P1Job = 2*(pi0) * rho;
PLess10 = 1 - 2*pi0*rho^9;
avg_t_queue = rho^2*D / (1-rho^2);
AvgQueueLen = lambda*avg_t_queue;
AvgRespTime = D / (1-rho^2);


fprintf("<strong>M/M/2\n</strong>");
fprintf("Total utilization: %g\n", tot_utilization);
fprintf("Average utilization: %g\n", avg_utilization);
fprintf("Probability of having exactly 1 job in the system: %g\n", P1Job);
fprintf("Probability of having < 10 jobs in the system: %g\n", PLess10);
fprintf("Average queue length: %g\n", AvgQueueLen);
fprintf("Average response time: %g\n", AvgRespTime);