## Fitting

The files _Trace1.csv_, _Trace2.csv_ and _Trace3.csv_ contain a single column that reports service times of two different file servers.

I computed for each file the first three moments, then I fitted the samples against:
- The Uniform, the Exponential and the Erlang distributions using direct expressions.
- The Weibull and the Pareto distributions with the method of moments.
- The two stage Hyper-Exponential and the two stage Hypo-Exponential distributions using the maximum likelihood technique.

The plotted figures are the comparisons for each trace of the empirical CDF of the samples with the real CDF of the distribution.
