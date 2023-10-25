function X = generateArrival(l1_hyper, l2_hyper, p1)
        rand_num_1 = rand();
        rand_num_2 = rand();
        X = (rand_num_1 <= p1) .* (-log(rand_num_2) / l1_hyper) + (rand_num_1 > p1) .* (-log(rand_num_2) / l2_hyper);
end