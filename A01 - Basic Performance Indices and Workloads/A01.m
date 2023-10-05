%get number of lines
file = fopen('barrier.log','r');
counter = 0;
while ~feof(file)
    line=fgetl(file);
    counter=counter+1;
end
fclose(file);

%store data on matrix
m=zeros(counter,2);
dates = zeros(counter, 1);
counter = 1;
n_in=0;
n_out=0;
ref = 0.0;
file = fopen('barrier.log','r');
while ~feof(file)
    line=fgetl(file);
    % Regex
    tokens = regexp(line, '\[(\d+):(\d+):(\d+):(\d+):(\d+):(\d+)\]\[(_\w+)\]', 'tokens');
    
    if ~isempty(tokens)
        % Estrai i dati dalla riga
        year = str2double(tokens{1}{1});
        day = str2double(tokens{1}{2});
        hour = str2double(tokens{1}{3});
        minute = str2double(tokens{1}{4});
        second = str2double(tokens{1}{5});
        decimal = str2double(tokens{1}{6});
        eventType = 0;
        if strcmp(tokens{1}{7}, "_OUT")
            eventType = 1;
            n_out=n_out+1;
        else
            n_in=n_in+1;
        end

        data_ora = datetime(year, 1, day, hour, minute, second, decimal*100);
        numero_giorni = datenum(data_ora);
        if ref==0
            ref = numero_giorni;
        end

        numero_giorni = numero_giorni - ref;
        sec = numero_giorni * 24 * 60 * 60;
      
        m(counter, 1) = sec;
        m(counter, 2) = eventType;
    end
    counter=counter+1;
end
fclose(file);
arrival_m = zeros(n_in, 1);
departure_m = zeros(n_out, 1);
i_in = 1;
i_out = 1;
for i = 1:counter-1
    if m(i, 2) == 0
        arrival_m(i_in, 1) = m(i, 1);
        i_in = i_in +1;
    else
        departure_m(i_out, 1) = m(i, 1);
        i_out = i_out +1;
    end
end

format short e
%Total time
T = m(counter-1, 1);

%Arrivals
arrivals = n_in;

%Departures
departures = n_out;

%Arrival rate
arrival_rate = (arrivals/T);

%Throughput
throughput = (departures/T);

%Average response time
res_time_m=(departure_m-arrival_m);
average_response_time = mean(res_time_m(:));

%Average inter arrival time
inter_arr_m = diff(arrival_m);
average_inter_arrival_time = mean(inter_arr_m);

%Average service time
serv_time_m = zeros(departures, 1);
serv_time_m(1,1) = res_time_m(1,1);
for i = 2:(size(departure_m))
    serv_time_m(i,1) = (departure_m(i,1)-max(departure_m(i-1,1),arrival_m(i,1)));
end
average_service_time = mean(serv_time_m(:));

%Utilization
utilization = throughput*average_service_time;

%Average number of jobs
average_num_jobs = throughput*average_response_time;

%Probability of having m parts in the machine (with m = 0, 1, 2)
event = zeros(size(m));
event(:, 1) = m(:, 2);
in_sys = 0;
for i=1:(departures+arrivals)
    if event(i, 1)==0
        in_sys = in_sys +1;
    else
        in_sys = in_sys -1;
    end
    event(i, 2) = in_sys;
end

count1 = 0;
count2 = 0;
count3 = 0;
m_part1 = 0;
m_part2 = 1;
m_part3 = 2;

for i=1:(size(event(:, 1))-1)
    if event(i, 2) == m_part1
        count1 = count1+(m(i+1,1)-m(i,1));
    end
    if event(i, 2) == m_part2
        count2 = count2+(m(i+1,1)-m(i,1));
    end
    if event(i, 2) == m_part3
        count3 = count3+(m(i+1,1)-m(i,1));
    end
end

prob_m1 = count1 / T;
prob_m2 = count2 / T;
prob_m3 = count3 / T;


%%%%%%%%%%%%%%%
%Probability of having a response time less than t, (with t = 30 sec, 3 min)
pr_r_30= sum(res_time_m<30)/departures;
pr_r_180= sum(res_time_m<180)/departures;

%Probability of having a service time longer than t, (with t = 1 min)
pr_s_60= sum(serv_time_m>60)/departures;

%Probability of having an inter arrival time shorter than tau, (with tau = 1 min)
pr_a_60= sum(inter_arr_m<60)/departures;

%Print values
fprintf(1,"Arrival rate: %g\n", arrival_rate);
fprintf(1,"Throughput: %g\n", throughput);
fprintf(1,"Average inter-arrival time: %g\n", average_inter_arrival_time);
fprintf(1,"Utilization: %g\n", utilization);
fprintf(1,"Average Service time: %g\n", average_service_time);
fprintf(1,"Average Number of jobs: %g\n", average_num_jobs);
fprintf(1,"Average Response time: %g\n", average_response_time);
fprintf(1,"Probability(m=0): %g\n", prob_m1);
fprintf(1,"Probability(m=1): %g\n", prob_m2);
fprintf(1,"Probability(m=2): %g\n", prob_m3);
fprintf(1,"Probability(Responde time<30sec): %g\n", pr_r_30);
fprintf(1,"Probability(Responde time<3min): %g\n", pr_r_180);
fprintf(1,"Probability(inter-arrival<1min): %g\n", pr_a_60);
fprintf(1,"Probability(Service time>1min): %g\n", pr_s_60);





