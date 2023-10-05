%Column 1 is inter-arrival time, column 2 is service time
m1 = csvread("Trace1.csv"); 
m2 = csvread("Trace2.csv");
m3 = csvread("Trace3.csv");

avg_ser_t = [mean(m1(:,2)) mean(m2(:,2)) mean(m3(:,2))];
avg_inter_arr = [mean(m1(:,1)) mean(m2(:,1)) mean(m3(:,1))];
arrivals = [size(m1,1) size(m2,1) size(m3,1)];
arrival_rate = 1./avg_inter_arr;

%Utilization
utilization = arrival_rate.*avg_ser_t;

%busy_t = utilization.*T;
busy_t = [sum(m1(:,2)) sum(m2(:,2)) sum(m3(:,2))];

A = zeros(arrivals(1),3);
C = zeros(arrivals(1),3);
A(1,1) = m1(1,1);
A(1,2) = m2(1,1);
A(1,3) = m3(1,1);
C(1,1) = m1(1,2)+A(1,1);
C(1,2) = m2(1,2)+A(1,2);
C(1,3) = m3(1,2)+A(1,3);
for i = 2:size(C,1)
    A(i,1) = A(i-1,1)+m1(i,1);
    A(i,2) = A(i-1,2)+m2(i,1);
    A(i,3) = A(i-1,3)+m3(i,1);
end
for i = 2:size(C,1)
    C(i,1) = max(A(i,1), C(i-1,1))+m1(i,2);
    C(i,2) = max(A(i,2), C(i-1,2))+m2(i,2);
    C(i,3) = max(A(i,3), C(i-1,3))+m3(i,2);
end

res_t = [C(:,1)-A(:,1) C(:,2)-A(:,2) C(:,3)-A(:,3)];
avg_res_t = mean(res_t);
T = C(end,:);

%{
A1 = ones(arrivals(1),2);
A2 = ones(arrivals(1),2);
A3 = ones(arrivals(1),2);
A1(:,1) = A(:,1);
A2(:,1) = A(:,2);
A3(:,1) = A(:,3);
%}
A1 = [A(:,1) ones(arrivals(1,1),1)];
A2 = [A(:,2) ones(arrivals(1,2),1)];
A3 = [A(:,3) ones(arrivals(1,3),1)];
C1 = [C(:,1) -ones(arrivals(1,1),1)];
C2 = [C(:,2) -ones(arrivals(1,2),1)];
C3 = [C(:,3) -ones(arrivals(1,3),1)];

event_1 = sortrows(([A1;C1]),1);
event_2 = sortrows(([A2;C2]),1);
event_3 = sortrows(([A3;C3]),1);

event_1 = [event_1, ones(size(event_1,1),1)];
event_2 = [event_2, ones(size(event_2,1),1)];
event_3 = [event_3, ones(size(event_3,1),1)];

for i=2:size(event_1,1)
    if event_1(i, 2)==1
        event_1(i, 3) = event_1(i-1, 3) +1;
    else
        event_1(i, 3) = event_1(i-1, 3) -1;
    end

    if event_2(i, 2)==1
        event_2(i, 3) = event_2(i-1, 3) +1;
    else
        event_2(i, 3) = event_2(i-1, 3) -1;
    end

    if event_3(i, 2)==1
        event_3(i, 3) = event_3(i-1, 3) +1;
    else
        event_3(i, 3) = event_3(i-1, 3) -1;
    end
end

Y0 = [sum(event_1(:,3)==0) sum(event_2(:,3)==0) sum(event_3(:,3)==0)];
freq_idle = Y0./T;
t_idle = T-busy_t;
avg_idle_t = t_idle./Y0;
    
%Print values
fprintf(1, "Average response time: %g\n", avg_res_t);
fprintf(1, "Utilization: %g\n", utilization);
fprintf(1, "Frequency idle system: %g\n", freq_idle);
fprintf(1, "Average idle time: %g\n", avg_idle_t);






