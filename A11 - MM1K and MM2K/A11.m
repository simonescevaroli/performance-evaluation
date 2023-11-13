clear;

%% Scenario 1
lambda = 150/60;   % req/sec
D = 350/1000;   % seconds
mu = 1 / D;
rho = lambda / mu;
k = 32;
utilization = (rho - rho^(k+1)) / (1 - rho^(k+1));
loss_prob = (rho^k - rho^(k+1)) / (1 - rho^(k+1));
N = rho/(1-rho) - ((k+1)*rho^(k+1)) / (1-rho^(k+1));
drop_rate = lambda * loss_prob;
avg_res_t = N / (lambda * (1-loss_prob));
avg_t_queue = avg_res_t - D;


fprintf("<strong>M/M/1/K\n</strong>");
fprintf("Utilization: %g\n", utilization);
fprintf("Loss probability: %g\n", loss_prob);
fprintf("Average number of jobs in the system: %g\n", N);
fprintf("Drop rate: %g\n", drop_rate);
fprintf("Average response time: %g\n", avg_res_t);
fprintf("Average time spent in the queue: %g\n\n", avg_t_queue);

%% Scenario 2
lambda = 250/60;   % req/sec
D = 350/1000;   % seconds
mu = 1 / D;
rho = lambda / (2 * mu);
k = 32;
p0 = 1/(2*rho^2 * (1-rho^(k-1))/(1-rho)+1+2*rho);
pn = [p0*2*rho, p0*2*rho.^(2:k)];
tot_utilization = pn(1,1)+pn(1,2)*2 + 2*(sum(pn(1,3:k)));
avg_utilization = tot_utilization/2;
loss_prob = pn(1, end);
avg_jobs_sys = pn * (1:k)';
drop_rate = lambda * loss_prob;
X = lambda * (1 - loss_prob);
avg_res_t = avg_jobs_sys / X;
avg_t_queue = avg_res_t - D;


fprintf("<strong>M/M/2/K\n</strong>");
fprintf("Total utilization: %g\n", tot_utilization);
fprintf("Average utilization: %g\n", avg_utilization);
fprintf("Loss probability: %g\n", loss_prob);
fprintf("Average number of jobs in the system: %g\n", avg_jobs_sys);
fprintf("Drop rate: %g\n", drop_rate);
fprintf("Average response time: %g\n", avg_res_t);
fprintf("Average time spent in the queue: %g\n", avg_t_queue);



