clear;

sn = 1/18;    %sleep_night -> scan
sds = 1/3;    %sleep_day_sun -> scan
sdc = 1/8;    %sleep_day_cloudy -> scan
sc = 1/2;     %scan_day -> sleep_night, sleep_day_sun, sleep_day_cloudy
pn = 12/24;   %probability of being night
ps = 8/24;    %probability of being sunny_day
pc = 4/24;    %probability of being cloudy_day

%infinitesimal generator matrix
Q = [  -sn,     0,     0,            sn;
         0,  -sds,     0,           sds;
         0,     0,  -sdc,           sdc;
     sc*pn, sc*ps, sc*pc, -sc*(pn+pc+ps)];

%steady-state solution
Qp = [Q(:,1:3), ones(4,1)];
plimit = [0, 0, 0, 1] * inv(Qp);

%reward vector for power consumption
costW = [0.1, 0.1, 0.1, 12];
%reward vector for utilization
rewardUtil = [0, 0, 0, 1];
%reward matrix for throughput
rewardScans = [0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0;
               1, 1, 1, 0];

%compute the metrics
avgPowerCons = plimit * costW';
utilization = plimit * rewardUtil';
scanMin = plimit * sum((rewardScans.*Q)')';
scanDay = scanMin*60*24;

fprintf("Average power consuption: %g\n", avgPowerCons);
fprintf("Utilization: %g\n", utilization);
fprintf("Throughput: %g\n", scanDay);