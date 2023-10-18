clear;
DS = [readmatrix("Trace1.csv") readmatrix("Trace2.csv")];
sDS = sort(DS);
N = size(sDS,1);
t = (1:N) / N;
t1 = (0: 0.1 : sDS(end, 1));
t2 = (0: 0.1 : sDS(end, 2));

%Mean 
M1 = mean(sDS);
%Second moment
M2 = sum(sDS.^2)/N;
%Third moment
M3 = sum(sDS.^3)/N;

Sigma = std(sDS);
cv = Sigma./M1;


%Fitting Uniform distribution using direct expression
a = M1 - sqrt(12*(M2-M1.^2))/2;
b = M1 + sqrt(12*(M2-M1.^2))/2;
Uniform_cdf1 = max(0, min(1, (t1>a(1,1)) .* (t1<b(1,1)) .* (t1 - a(1,1)) / (b(1,1) - a(1,1)) + (t1 >= b(1,1))));
Uniform_cdf2 = max(0, min(1, (t2>a(1,2)) .* (t2<b(1,2)) .* (t2 - a(1,2)) / (b(1,2) - a(1,2)) + (t2 >= b(1,2))));

%Fitting Exponential distribution using direct expression
lambda_exp = 1./M1;
Exponential_cdf1 = max(0, 1 - exp(-lambda_exp(1,1)*t1));
Exponential_cdf2 = max(0, 1 - exp(-lambda_exp(1,2)*t2));

%Fitting Erlang distribution using direct expression
k_erlang = round(1./cv.^2);
lambda_erlang = k_erlang./M1;

%Trace1
if cv(1,1) < 1
    acc = 0;
    for j = 0:k_erlang(1,1)-1
        acc = acc + (1/factorial(j)).*exp(-lambda_erlang(1,1).*t1).*(lambda_erlang(1,1).*t1).^j;
    end
    Erlang_cdf1 = 1 - acc;
end

if cv(1,2) < 1
    acc = 0;
    for j = 0:k_erlang(1,2)-1
        acc = acc + (1/factorial(j)).*exp(-lambda_erlang(1,2).*t1).*(lambda_erlang(1,2).*t1).^j;
    end
    Erlang_cdf2 = 1 - acc;
end




%Fitting Weibull distribution using method of moments
%{
Two equations for two parameters -> first and second moments
Estimate shape (k) and scale (lambda) parameters
    x(1) = lambda
    x(2) = k
%}
eq1 = @(x) [x(1)*gamma(1+1/x(2))-M1(1,1), x(1)^2*gamma(1+2/x(2))-M2(1,1)];
eq2 = @(x) [x(1)*gamma(1+1/x(2))-M1(1,2), x(1)^2*gamma(1+2/x(2))-M2(1,2)];
par_t1 = fsolve(eq1, [1,1]);
par_t2 = fsolve(eq2, [1,1]);
lambda_weibull = [par_t1(1) par_t2(1)];
k_weibull = [par_t1(2) par_t2(2)];
Weibull_cdf1 = 1-exp(-(t1./lambda_weibull(1,1)).^k_weibull(1,1));
Weibull_cdf2 = 1-exp(-(t2./lambda_weibull(1,2)).^k_weibull(1,2));



%Fitting Pareto distribution using method of moments
%{
Two equations for two parameters -> first and second moments
Estimate shape (alpha) and scale (m) parameters
    x(1) = alpha
    x(2) = m
%}
eq1 = @(x) [(x(1)*x(2))/(x(1)-1)-M1(1,1), (x(1)*x(2)^2)/(x(1)-2)-M2(1,1)];
eq2 = @(x) [(x(1)*x(2))/(x(1)-1)-M1(1,2), (x(1)*x(2)^2)/(x(1)-2)-M2(1,2)];
par_t1 = fsolve(eq1, [4,3]);
par_t2 = fsolve(eq2, [4,3]);
alpha_pareto = [par_t1(1) par_t2(1)];
m_pareto = [par_t1(2) par_t2(2)];
Pareto_cdf1 = (t1>=m_pareto(1,1)).*(1-(m_pareto(1,1)./t1).^alpha_pareto(1,1));
Pareto_cdf2 = (t2>=m_pareto(1,2)).*(1-(m_pareto(1,2)./t2).^alpha_pareto(1,2));


fprintf("Mean: %g %g\n", M1);
fprintf("Moment2: %g %g\n", M2);
fprintf("Moment3: %g %g\n", M3);
fprintf("Uniform_a: %g %g\n", a);
fprintf("Uniform_b: %g %g\n", b);
fprintf("Exponential_lambda: %g %g\n", lambda_exp);
fprintf("Erlang_k (stages): %g %g\n", k_erlang);
fprintf("Erlang_lambda (rate): %g %g\n", lambda_erlang);
if cv(1,1) > 1
    fprintf("Erlang not possible in Trace1 -> cv = %g > 1\n", cv(1,1));
end
if cv(1,2) > 1
    fprintf("Erlang not possible in Trace2 -> cv = %g > 1\n", cv(1,2));
end
fprintf("Weibull_k (shape): %g %g\n", k_weibull);
fprintf("Weibull_lambda (scale): %g %g\n", lambda_weibull);
fprintf("Pareto_alpha (shape): %g %g\n", alpha_pareto);
fprintf("Pareto_m (scale): %g %g\n", m_pareto);


%Fitting 2-stage Hyper-Exponential distribution using maximum likelihood technique
Hyperexp_pdf = @(x, l1, l2, p1) p1*l1*exp(-l1*x) + (1-p1)*l2*exp(-l2*x);

%Trace1
Hyper1_param = mle(sDS(:,1), 'pdf', Hyperexp_pdf, 'Start', [0.8/M1(1,1), 1.2/M1(1,1), 0.4]);
fprintf("Hyper-exponential Trace1 (lambda1, lambda2, p1): %g %g %g\n", Hyper1_param);
Hyperexp_cdf1 = 1 - (Hyper1_param(1,3) * exp(-Hyper1_param(1,1).*t1)) - (1-Hyper1_param(1,3)) * exp(-Hyper1_param(1,2).*t1);
if cv(1,1)<1
    fprintf("Hyper-Exponential not possible in Trace1 -> cv = %g < 1\n", cv(1,1));
end

%Trace2
Hyper2_param = mle(sDS(:,2), 'pdf', Hyperexp_pdf, 'Start', [0.8/M1(1,2), 1.2/M1(1,2), 0.4]);
fprintf("Hyper-exponential Trace2 (lambda1, lambda2, p1): %g %g %g\n", Hyper2_param);
Hyperexp_cdf2 = 1 - (Hyper2_param(1,3) * exp(-Hyper2_param(1,1).*t2)) - (1-Hyper2_param(1,3)) * exp(-Hyper2_param(1,2).*t2);
if cv(1,2)<1
    fprintf("Hyper-Exponential not possible in Trace2 -> cv = %g < 1\n", cv(1,2));
end

%Fitting 2-stage Hypo-Exponential distribution using maximum likelihood technique
Hypoexp_pdf = @(x, l1, l2) ((l1*l2)/(l1-l2))*(exp(-l2*x)-exp(-l1*x));

%Trace1
Hypo1_param(1,:) = mle(sDS(:,1), 'pdf', Hypoexp_pdf, 'Start', [1/(0.3*M1(1,1)), 1/(0.7*M1(1,1))]);
fprintf("Hypo-exponential Trace1 (lambda1, lambda2): %g %g\n", Hypo1_param);
Hypoexp_cdf1 = 1 - ((Hypo1_param(1,2)*exp(-Hypo1_param(1,1).*t1))/(Hypo1_param(1,2)-Hypo1_param(1,1))) + ((Hypo1_param(1,1)*exp(-Hypo1_param(1,2).*t1))/(Hypo1_param(1,2)-Hypo1_param(1,1)));
if cv(1,1)>1
    fprintf("Hypo-Exponential not possible in Trace1 -> cv = %g > 1\n", cv(1,1));
end

%Trace2
Hypo2_param = mle(sDS(:,2), 'pdf', Hypoexp_pdf, 'Start', [1/(0.3*M1(1,2)), 1/(0.7*M1(1,2))]);
fprintf("Hypo-exponential Trace2 (lambda1, lambda2): %g %g\n", Hypo2_param);
Hypoexp_cdf2 = 1 - ((Hypo2_param(1,2)*exp(-Hypo2_param(1,1).*t2))/(Hypo2_param(1,2)-Hypo2_param(1,1))) + ((Hypo2_param(1,1)*exp(-Hypo2_param(1,2).*t2))/(Hypo2_param(1,2)-Hypo2_param(1,1)));
if cv(1,2)>1
    fprintf("Hypo-Exponential not possible in Trace2 -> cv = %g > 1\n", cv(1,2));
end


hold on;
plot(sDS(:,1), t, "-");
plot(t1,Uniform_cdf1, "-");
plot(t1,Exponential_cdf1, "-");
plot(t1,Erlang_cdf1, "-");
plot(t1,Weibull_cdf1, "-");
plot(t1,Pareto_cdf1, "-");
plot(t1,Hypoexp_cdf1, "-");
title('CDF Comparison - Trace1');
legend('Dataset', 'Uniform', 'Exponential', 'Erlang', 'Weibull', 'Pareto', 'HypoExp');

figure;
hold on;
plot(sDS(:,2), t, "-");
plot(t2,Uniform_cdf2, "-");
plot(t2, Exponential_cdf2, "-");
plot(t2,Weibull_cdf2, "-");
plot(t2,Pareto_cdf2, "-");
plot(t2,Hyperexp_cdf2, "-");
title('CDF Comparison - Trace2');
legend('Dataset', 'Uniform', 'Exponential', 'Weibull', 'Pareto', 'HyperExp');