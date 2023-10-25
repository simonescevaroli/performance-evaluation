clear;
rng(0);

i = 0;
s = 1;
n_games = 100000;
t = 0;

dt = 0;
C = 0;


while i < n_games
    %ENTRANCE
    if s == 1
        if rand() < 0.7    %follow yellow path
            if rand() < 0.8    %success, go to C1
                l = 1.5;
                dt = -(log(rand()) + log(rand()) + log(rand()) + log(rand())) / l;
                ns = 2;
            else     %fall, go to LAVA
                l = 0.5;
                dt = -log(rand())/l;
                ns = 5;
            end
        else     %follow light blue path
            if rand() < 0.3     %success, reach C2
                a = 3;
                b = 6;
                dt = a + rand()*(b-a);
                ns = 3;
            else    %fall, go to LAVA
                l = 0.25;
                dt = -log(rand())/l;
                ns = 5;
            end
        end
    end

    %C1
    if s == 2
        if rand() < 0.5     %follow yellow path
            if rand() < 0.25     %success, reach C2
                l = 2;
                dt = -(log(rand()) + log(rand()) + log(rand())) / l;
                ns = 3;
            else    %fall, go to LAVA
                l = 0.4;
                dt = -log(rand())/l;
                ns = 5;
            end
        else    %follow white path
            if rand() < 0.6    %success, go to C2
                l = 0.15;
                dt = -log(rand())/l;
                ns = 3;
            else     %fall, go to LAVA
                l = 0.2;
                dt = -log(rand())/l;
                ns = 5;
            end
        end
    end
    
    %C2
    if s == 3
        if rand() < 0.6    %success, green path, reach EXIT
            l = 4;
            dt = -(log(rand()) + log(rand()) + log(rand()) + log(rand()) + log(rand())) / l;
            ns = 4;
        else     %fall, go to LAVA
            l = 4;
            dt = -(log(rand()) + log(rand()) + log(rand()) + log(rand()) + log(rand())) / l;
            ns = 5;
        end
    end

    %EXIT
    if s == 4
        dt = 5;
        ns = 1;
        C = C + 1;
        i = i + 1;
    end

    %LAVA
    if s == 5
        dt = 5;
        ns = 1;
        i = i + 1;
    end

    s = ns;
    t = t + dt;
end

win_prob = C / n_games;
avg_duration = (t-5*n_games) / n_games;
X = (n_games / t)*60;

fprintf("Number of games: %g\n", n_games);
fprintf("Winning probability: %g\n", win_prob);
fprintf("Average duration time: %g min\n", avg_duration);
fprintf("Throughput: %g per hour\n", X);

