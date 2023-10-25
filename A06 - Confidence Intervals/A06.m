%% Scenario 1
clear;
rng(0);
%Define the distributions for arrival and service times
l1_hyper = 0.02;
l2_hyper = 0.2;
p1 = 0.1;

k_erlang = 10;
l_erlang = 1.5;

arrivalRnd = @() generateArrival(l1_hyper, l2_hyper, p1);
serviceRnd = @() -log(prod(rand(k_erlang, 1))) / l_erlang;

%Parameters
gam = 0.95;
d = norminv((1+gam)/2);

M = 1000;
rel_error = 0.04;

K0 = 1000;          %can be changed
maxK = 20000;       %can be changed
DK = 100;            %can be changed

%Initializing parameters for the metrics to be computed
K = K0;

%Keep track of global arrival and completion times
tA = 0;
tC = 0;

%Initializing cumulators for all the metrics and square of these metrics
%{
    U = utilization
    X = throughput
    J = average number of jobs in the system
    R = average response time
    RV = variance of the response time
%}
U = 0;
U2 = 0;
X = 0;
X2 = 0;
J = 0;
J2 = 0;
R = 0;
R2 = 0;
RV = 0;
RV2 = 0;

%First we do K0 batch, then newIters will become DK
newIters = K;

while K < maxK
    for i = 1:newIters
        Bi = 0;
        Wi = 0;
        tA0 = tA;

        %Vector that stores all the response times for a batch
        RAlli = zeros(M, 1);
        
        for j = 1:M
            
            %Draw two random relative arrival and service times
            a_ji = arrivalRnd();
            s_ji = serviceRnd();
            
            %Compute the absolute arrival time given the current job
            tA = tA + a_ji;
            
            %Compute and mantain up to date the completion time and the
            %response time of the current job
            tC = max(tA, tC) + s_ji;
            ri = tC - tA;          
            
            %Update busy time
            Bi = Bi + s_ji;

            %Update W
            Wi = Wi + ri;

            %Store all the response times for a batch to compute the
            %variance
            RAlli(j, 1) = ri;
        end
        
        %Compute the measures for the i-th run and the accumulated measures
        %for which after we compute the average

        Ti = tC - tA0;

        %Utilization
        Ui = Bi / Ti;
        U = U + Ui;
        U2 = U2 + Ui^2;

        %Throughput
        Xi = M / Ti;
        X = X + Xi;
        X2 = X2 + Xi^2;

        %Average number of jobs in the system
        Ji = Wi / Ti;
        J = J + Ji;
        J2 = J2 + Ji^2;
        
        %Average response time
        Ri = Wi / M;
        R = R + Ri;
        R2 = R2 + Ri^2;
        
        %Variance of the response time
        Rvari = var(RAlli);
        RV = RV + Rvari;
        RV2 = RV2 + Rvari^2;
    end
    
    %Compute all the average measures, confidence intervals and errors

    %Utilization
    Um = U / K;
    Us = sqrt((U2 - U^2/K)/(K-1));
    CiU = [Um - d * Us / sqrt(K), Um + d * Us / sqrt(K)];
    errU = 2 * d * Us / sqrt(K) / Um;

    %Throughput
    Xm = X / K;
    Xs = sqrt((X2 - X^2/K)/(K-1));
    CiX = [Xm - d * Xs / sqrt(K), Xm + d * Xs / sqrt(K)];
    errX = 2 * d * Xs / sqrt(K) / Xm;

    %Average number of jobs in the system
    Jm = J / K;
    Js = sqrt((J2 - J^2/K)/(K-1));
    CiJ = [Jm - d * Js / sqrt(K), Jm + d * Js / sqrt(K)];
    errJ = 2 * d * Js / sqrt(K) / Jm;

    %Average response time
    Rm = R / K;
    Rs = sqrt((R2 - R^2/K)/(K-1));
    CiR = [Rm - d * Rs / sqrt(K), Rm + d * Rs / sqrt(K)];
    errR = 2 * d * Rs / sqrt(K) / Rm;
    
    %Variance of the response time
    RVm = RV / K;
    RVs = sqrt((RV2 - RV^2/K)/(K-1));
    CiRV = [RVm - d * RVs / sqrt(K), RVm + d * RVs / sqrt(K)];
    errRV = 2 * d * RVs / sqrt(K) / RVm;
    
    %If the error for every measure is below the threshold, stop
    if errU < rel_error && errX < rel_error && errJ < rel_error && errR < rel_error && errRV < rel_error
        break;
    %Otherwise, continue adding DK batches
    else
        K = K + DK;
        newIters = DK;
    end
end

fprintf(1, "<strong>Scenario 1</strong>\n");
fprintf("Confidence level: %g\tBatch dimension: %g jobs\tRelative error: %g\n", gam, M, rel_error);
if errU < rel_error && errX < rel_error && errJ < rel_error && errR < rel_error && errRV < rel_error
	fprintf(1, "Maximum Relative Error reached in K = %d batches\n\n", K);
else
	fprintf(1, "Maximum Relative Error NOT REACHED in K = %d batches\n\n", K);
end	

fprintf(1, "Utilization in [%g, %g]. Relative Error: %g\n", CiU(1,1), CiU(1,2), errU);
fprintf(1, "Throughput in [%g, %g]. Relative Error: %g\n", CiX(1,1), CiX(1,2), errX);
fprintf(1, "Average number of jobs in the system in [%g, %g]. Relative Error: %g\n", CiJ(1,1), CiJ(1,2), errJ);
fprintf(1, "Response time in [%g, %g]. Relative Error: %g\n", CiR(1,1), CiR(1,2), errR);
fprintf(1, "Variance of response time in [%g, %g]. Relative Error: %g\n\n", CiRV(1,1), CiRV(1,2), errRV);

%% Scenario 2
%Define the distributions for arrival and service time
l_exp = 0.1;
a_uni = 5;
b_uni = 10;
arrivalRnd = @() -log(rand()) / l_exp;
serviceRnd = @() a_uni + (b_uni - a_uni) * rand();

%Parameters
gam = 0.95;
d = norminv((1+gam)/2);

M = 1000;
rel_error = 0.04;

K0 = 1000;          %can be changed
maxK = 20000;       %can be changed
DK = 100;            %can be changed

%Initializing parameters for the metrics to be computed
K = K0;

%Keep track of global arrival and completion times
tA = 0;
tC = 0;

%Initializing cumulators for all the metrics and square of these metrics
%{
    U = utilization
    X = throughput
    J = average number of jobs in the system
    R = average response time
    RV = variance of the response time
%}
U = 0;
U2 = 0;
X = 0;
X2 = 0;
J = 0;
J2 = 0;
R = 0;
R2 = 0;
RV = 0;
RV2 = 0;

%First we do K0 batch, then newIters will become DK
newIters = K;

while K < maxK
    for i = 1:newIters
        Bi = 0;
        Wi = 0;
        tA0 = tA;

        %Vector that stores all the response times for a batch
        RAlli = zeros(M, 1);
        
        for j = 1:M
            
            %Draw two random relative arrival and service times
            a_ji = arrivalRnd();
            s_ji = serviceRnd();
            
            %Compute the absolute arrival time given the current job
            tA = tA + a_ji;
            
            %Compute and mantain up to date the completion time and the
            %response time of the current job
            tC = max(tA, tC) + s_ji;
            ri = tC - tA;          
            
            %Update busy time
            Bi = Bi + s_ji;

            %Update W
            Wi = Wi + ri;

            %Store all the response times for a batch to compute the
            %variance
            RAlli(j, 1) = ri;
        end
        
        %Compute the measures for the i-th run and the accumulated measures
        %for which after we compute the average

        Ti = tC - tA0;

        %Utilization
        Ui = Bi / Ti;
        U = U + Ui;
        U2 = U2 + Ui^2;

        %Throughput
        Xi = M / Ti;
        X = X + Xi;
        X2 = X2 + Xi^2;

        %Average number of jobs in the system
        Ji = Wi / Ti;
        J = J + Ji;
        J2 = J2 + Ji^2;
        
        %Average response time
        Ri = Wi / M;
        R = R + Ri;
        R2 = R2 + Ri^2;
        
        %Variance of the response time
        Rvari = var(RAlli);
        RV = RV + Rvari;
        RV2 = RV2 + Rvari^2;
    end
    
    %Compute all the average measures, confidence intervals and errors

    %Utilization
    Um = U / K;
    Us = sqrt((U2 - U^2/K)/(K-1));
    CiU = [Um - d * Us / sqrt(K), Um + d * Us / sqrt(K)];
    errU = 2 * d * Us / sqrt(K) / Um;

    %Throughput
    Xm = X / K;
    Xs = sqrt((X2 - X^2/K)/(K-1));
    CiX = [Xm - d * Xs / sqrt(K), Xm + d * Xs / sqrt(K)];
    errX = 2 * d * Xs / sqrt(K) / Xm;

    %Average number of jobs in the system
    Jm = J / K;
    Js = sqrt((J2 - J^2/K)/(K-1));
    CiJ = [Jm - d * Js / sqrt(K), Jm + d * Js / sqrt(K)];
    errJ = 2 * d * Js / sqrt(K) / Jm;

    %Average response time
    Rm = R / K;
    Rs = sqrt((R2 - R^2/K)/(K-1));
    CiR = [Rm - d * Rs / sqrt(K), Rm + d * Rs / sqrt(K)];
    errR = 2 * d * Rs / sqrt(K) / Rm;
    
    %Variance of the response time
    RVm = RV / K;
    RVs = sqrt((RV2 - RV^2/K)/(K-1));
    CiRV = [RVm - d * RVs / sqrt(K), RVm + d * RVs / sqrt(K)];
    errRV = 2 * d * RVs / sqrt(K) / RVm;
    
    %If the error for every measure is below the threshold, stop
    if errU < rel_error && errX < rel_error && errJ < rel_error && errR < rel_error && errRV < rel_error
        break;
    %Otherwise, continue adding DK batches
    else
        K = K + DK;
        newIters = DK;
    end
end

fprintf(1, "<strong>Scenario 2</strong>\n");
fprintf("Confidence level: %g\tBatch dimension: %g jobs\tRelative error: %g\n", gam, M, rel_error);
if errU < rel_error && errX < rel_error && errJ < rel_error && errR < rel_error && errRV < rel_error
	fprintf(1, "Maximum Relative Error reached in K = %d batches\n\n", K);
else
	fprintf(1, "Maximum Relative Error NOT REACHED in K = %d batches\n\n", K);
end	

fprintf(1, "Utilization in [%g, %g]. Relative Error: %g\n", CiU(1,1), CiU(1,2), errU);
fprintf(1, "Throughput in [%g, %g]. Relative Error: %g\n", CiX(1,1), CiX(1,2), errX);
fprintf(1, "Average number of jobs in the system in [%g, %g]. Relative Error: %g\n", CiJ(1,1), CiJ(1,2), errJ);
fprintf(1, "Response time in [%g, %g]. Relative Error: %g\n", CiR(1,1), CiR(1,2), errR);
fprintf(1, "Variance of response time in [%g, %g]. Relative Error: %g\n", CiRV(1,1), CiRV(1,2), errRV);