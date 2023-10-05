m = sort([csvread("Trace1.csv") csvread("Trace2.csv") csvread("Trace3.csv")]);
ds = [csvread("Trace1.csv") csvread("Trace2.csv") csvread("Trace3.csv")];
N = size(m,1);

%Plot of approximated CDF
subplot(3, 1, 1);
plot(m(:,1), [1:N]/N, ".");
title('Trace 1');
subplot(3, 1, 2);
plot(m(:,2), [1:N]/N, ".");
title('Trace 2');
subplot(3, 1, 3);
plot(m(:,3), [1:N]/N, ".");
title('Trace 3');
sgtitle('Cumulative Distribution Function');

%Mean
M1 = sum(m)/N;

%Second moment
M2 = sum(m.^2)/N;

%Third moment
M3 = sum(m.^3)/N;

%Fourth moment
M4 = sum(m.^4)/N;

%Variance
C2 = sum((m-M1).^2)/N;

%Third centered moment
C3 = sum((m-M1).^3)/N;

%Fourth centered moment
C4 = sum((m-M1).^4)/N;

%Standard deviation
Sigma = sqrt(C2);

%Skewness
S3 = sum(((m-M1)./Sigma).^3)/N;

%Fourth centered moment
S4 = sum(((m-M1)./Sigma).^4)/N;

%Coefficent of variation
Cv = Sigma./M1;

%Excess Kurtosis
exKurt=S4-3;

%Median
h50 = (N-1)*0.50+1;
ih50 = floor(h50);
d50 = h50-ih50;
Q50 = m(ih50,:)+d50*(m(ih50+1,:)-m(ih50,:));

%First quartile
h25 = (N-1)*0.25+1;
ih25 = floor(h25);
d25 = h25-ih25;
Q25 = m(ih25,:)+d25*(m(ih25+1,:)-m(ih25,:));

%Third quartile
h75 = (N-1)*0.75+1;
ih75 = floor(h75);
d75 = h75-ih75;
Q75 = m(ih75,:)+d75*(m(ih75+1,:)-m(ih75,:));

%cross covariance
k=100;
X_cov = zeros(k,3);
for i=1:k
    X_cov(i,:) = (sum((ds(1:end-i,:)-M1).*(ds(1+i:end,:)-M1))/(N-i))./C2;
end
figure;
subplot(3, 1, 1);
plot(1:k,X_cov(:,1),"-");
title('Trace 1');
subplot(3, 1, 2);
plot(1:k,X_cov(:,2),"-");
title('Trace 2');
subplot(3, 1, 3);
plot(1:k,X_cov(:,3),"-");
title('Trace 3');
sgtitle('Pearson Correlation Coefficent')

%Print values
fprintf(1,"Mean: %g\n", M1);
fprintf(1,"Second moment: %g\n", M2);
fprintf(1,"Third moment: %g\n", M3);
fprintf(1,"Fourth moment: %g\n", M4);
fprintf(1,"Variance: %g\n", C2);
fprintf(1,"Third centered moment: %g\n", C3);
fprintf(1,"Fourth centered moment: %g\n", C4);
fprintf(1,"Skewness: %g\n", S3);
fprintf(1,"Fourth standardized moment: %g\n", S4);
fprintf(1,"Standard deviation: %g\n", Sigma);
fprintf(1,"Coefficient of variation: %g\n", Cv);
fprintf(1,"Excess Kurtosis: %g\n", exKurt);
fprintf(1,"Median: %g\n", Q50);
fprintf(1,"First quartile: %g\n", Q25);
fprintf(1,"Third quartile: %g\n", Q75);




