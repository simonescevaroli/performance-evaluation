clear;
S = [10, 12;
      4,  3;
      6,  6];
v = [1, 1;
     1, 1;
     1, 1];

D = v .* S;
lambda = [2; 3; 2.5] / 60;
Uck = D .* [lambda, lambda];
Uk = sum(Uck);

% Throughput
Xc = lambda;
Xck = v .* [lambda, lambda];
Xk = sum(Xck);
X = sum(Xc);

% Residence time
Rck = D ./ (1 - [Uk; Uk; Uk]);

% Class response time
PHIck = Rck ./ v;
PHIc = sum(PHIck')';

% Number of jobs
Nck = Xck .* PHIck;
Nc = sum(Nck')';

% Class-indipendent system response time
PHIk = sum(Xck ./ [Xk; Xk; Xk] .* PHIck);
PHI = sum(PHIk);




fprintf("Utilization Production: %g\n", Uk(1, 1));
fprintf("Utilization Packaging: %g\n", Uk(1, 2));
fprintf("Average number of jobs in the system (A): %g\n", Nc(1,1));
fprintf("Average number of jobs in the system (B): %g\n", Nc(2,1));
fprintf("Average number of jobs in the system (C): %g\n", Nc(3,1));
fprintf("Average system response time (A): %g\n", PHIc(1,1));
fprintf("Average system response time (B): %g\n", PHIc(2,1));
fprintf("Average system response time (C): %g\n", PHIc(3,1));
fprintf("Class-independent average system response time: %g\n", PHI);