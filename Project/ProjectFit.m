clear;
%% Pre process
% In order traces are W, S, P, I
% Traces are divided by 60000 to obtain minutes from ms
sDS = sort([load("Traces/TraceC-W.txt") load("Traces/TraceC-S.txt") load("Traces/TraceC-P.txt") load("Traces/TraceC-I.txt")]);
sDS = sDS/60000;

% All the traces have the same size
N = size(sDS, 1);
t = (1:N) / N;
t_W = (0: 0.1 : sDS(end, 1));
t_S = (0: 0.1 : sDS(end, 2));
t_P = (0: 0.1 : sDS(end, 3));
t_I = (0: 0.1 : sDS(end, 4));

% Plot of the traces
%{
plot(sDS(:,1), t, "-");
figure;
plot(sDS(:,2), t, "-");
figure;
plot(sDS(:,3), t, "-");
figure;
plot(sDS(:,4), t, "-");
%}

% Mean 
M1 = mean(sDS);
% Second moment
M2 = sum(sDS.^2)/N;
% Third moment
M3 = sum(sDS.^3)/N;

Sigma = std(sDS);
cv = Sigma./M1;

%% Considerations
% Looking at the plot of the traces and their CVs, it's possible that:
% Trace W -> it could be a Hypoexp or an Erlang (cv < 1) or a Weibull
% Trace S -> it could be an Exponential (cv ~ 1)
% Trace P -> it could be an Exponential (cv ~ 1)
% Trace I -> it could be a Hyperexp (cv > 1)

%% Fitting
% TRACE W
% Fitting 2-stage Hypo-Exponential distribution using maximum likelihood technique
% cv < 1
Hypoexp_pdf = @(x, l1, l2) ((l1*l2)/(l1-l2))*(exp(-l2*x)-exp(-l1*x));

Hypo_W_param(1,:) = mle(sDS(:,1), 'pdf', Hypoexp_pdf, 'Start', [1/(0.3*M1(1,1)), 1/(0.7*M1(1,1))]);
Hypoexp_cdf_W = 1 - ((Hypo_W_param(1,2)*exp(-Hypo_W_param(1,1).*t_W))/(Hypo_W_param(1,2)-Hypo_W_param(1,1))) + ((Hypo_W_param(1,1)*exp(-Hypo_W_param(1,2).*t_W))/(Hypo_W_param(1,2)-Hypo_W_param(1,1)));


% Fitting Erlang distribution using direct expression
% cv < 1
k_erlang = round(1/cv(1,1)^2);
lambda_erlang = k_erlang/M1(1,1);

acc = 0;
for j = 0:k_erlang-1
    acc = acc + (1/factorial(j)).*exp(-lambda_erlang.*t_W).*(lambda_erlang.*t_W).^j;
end
Erlang_cdf_W = 1 - acc;


% Fitting Weibull distribution using method of moments
eq = @(x) [x(1)*gamma(1+1/x(2))-M1(1,1), x(1)^2*gamma(1+2/x(2))-M2(1,1)];
par_t_W = fsolve(eq, [1,1]);
lambda_weibull = par_t_W(1);
k_weibull = par_t_W(2);
Weibull_cdf_W = 1-exp(-(t_W./lambda_weibull).^k_weibull);


% TRACEs S and P
% Fitting Exponential distribution using direct expression
% cv ~ 1
lambda_exp = 1./M1;
Exponential_cdf_S = max(0, 1 - exp(-lambda_exp(1,2)*t_S));
Exponential_cdf_P = max(0, 1 - exp(-lambda_exp(1,3)*t_P));


% TRACE I
% Fitting 2-stage Hyper-Exponential distribution using maximum likelihood technique
% cv > 1
Hyperexp_pdf = @(x, l1, l2, p1) p1*l1*exp(-l1*x) + (1-p1)*l2*exp(-l2*x);

Hyper_I_param = mle(sDS(:,4), 'pdf', Hyperexp_pdf, 'Start', [0.8/M1(1,4), 1.2/M1(1,4), 0.4]);
Hyperexp_cdf_I = 1 - (Hyper_I_param(1,3) * exp(-Hyper_I_param(1,1).*t_I)) - (1-Hyper_I_param(1,3)) * exp(-Hyper_I_param(1,2).*t_I);

%% Plot
% To visualize the plot with all the cdf, you need to remove the "/60000" at the
% beginning in the dataset, otherwise will result in blank plots
%{
hold on;
plot(sDS(:,1), t, "-");
plot(t_W,Erlang_cdf_W, "-");
plot(t_W,Hypoexp_cdf_W, "-");
plot(t_W,Weibull_cdf_W, "-");
title('CDF Comparison - Trace W');
legend('Dataset', 'Erlang', 'Hypo', 'Weibull');

figure;
hold on;
plot(sDS(:,2), t, "-");
plot(t_S, Exponential_cdf_S, "-");
title('CDF Comparison - Trace S');
legend('Dataset','Exponential');

figure;
hold on;
plot(sDS(:,3), t, "-");
plot(t_P, Exponential_cdf_P, "-");
title('CDF Comparison - Trace P');
legend('Dataset','Exponential');

figure;
hold on;
plot(sDS(:,4), t, "-");
plot(t_I, Hyperexp_cdf_I, "-");
title('CDF Comparison - Trace I');
legend('Dataset','HyperExp');
%}

% Looking at the plot it is clear that the best distributions are:
% Trace W -> Erlang
% Trace S -> Exponential
% Trace P -> Exponential
% Trace I -> Hyperexp


%% Parameters found for best fit
% Trace W
fprintf("Erlang parameters for Trace W (k, lambda): %g %g\n", k_erlang(1,1), lambda_erlang(1,1));
% Trace S
fprintf("Exponential parameter for Trace S (lambda): %g\n", lambda_exp(1,2));
% Trace P
fprintf("Exponential parameter for Trace P (lambda): %g\n", lambda_exp(1,3));
% Trace I
fprintf("Hyper-exponential parameters for Trace I (lambda1, lambda2, p1): %g %g %g\n", Hyper_I_param);



