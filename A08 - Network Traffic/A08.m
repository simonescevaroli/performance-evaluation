clear;

l1 = 0.33;      %low -> medium
m1 = 0.6;       %medium -> low
m2 = 0.4;       %medium -> high
h1 = 1;         %high -> medium
d1 = 0.05;      %low, medium, high -> down
p1 = 0.6;
p2 = 0.3;
p3 = 0.1;
d2 = p1 * 6;         %down -> low
d3 = p2 * 6;         %down -> medium
d4 = p3 * 6;         %down -> high

Q = [-l1-d1,        l1,      0,        d1;
         m1, -m1-m2-d1,     m2,        d1;
          0,        h1, -h1-d1,        d1;
         d2,        d3,     d4, -d2-d3-d4];

p0_1 = [0, 1, 0, 0];
[t, Sol] = ode45(@(t,x) Q'*x, [0 8], p0_1');
plot(t, Sol, "-");
title("Simulation with starting point: MEDIUM");
legend("Low", "Medium", "High", "Down");

figure;
p0_2 = [0, 0, 0, 1];
[t, Sol] = ode45(@(t,x) Q'*x, [0 8], p0_2');
plot(t, Sol, "-");
title("Simulation with starting point: DOWN");
legend("Low", "Medium", "High", "Down");

