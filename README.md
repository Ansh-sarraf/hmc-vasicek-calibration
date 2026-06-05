# Hamiltonian Monte Carlo: From Physics Intuition to Advanced Applications

**Author:** Ansh Sarraf (BSD-DH-2406)
**Co-author:** Antareep (BSD-CC-2406)
**Institution:** Indian Statistical Institute, Delhi Centre

## Overview
Markov Chain Monte Carlo (MCMC) methods are the backbone of Bayesian computation, yet classical algorithms such as the Metropolis-Hastings sampler suffer from slow exploration in high-dimensional and highly correlated target distributions. This project provides a mathematically rigorous treatment of the Hamiltonian Monte Carlo (HMC) algorithm, which resolves these limitations by embedding the sampling problem within the framework of classical Hamiltonian mechanics.

## Key Contributions
* **Mathematical Derivations:** Proves the two essential geometric properties of the leapfrog integrator—time-reversibility and volume preservation (symplecticity)—and uses these to rigorously establish that HMC satisfies the detailed balance condition.
* **Algorithm Scaling Analysis:** Demonstrates that HMC requires $O(d^{5/4})$ gradient evaluations compared to the $O(d^{2})$ steps required by standard random-walk MCMC.
* **Geometric Visualization:** Implements the leapfrog integrator in R (ggplot2) to visualize the HMC trajectory on a 2D standard Gaussian target, demonstrating how the trajectory follows high-density elliptical shells.
* **Bayesian SDE Calibration:** Applies the No-U-Turn Sampler (NUTS) via Stan (`rstan`) for posterior inference of the Vasicek stochastic differential equation parameters.

## Repository Contents
* `HMC_Report_Ansh_Sarraf.pdf`: The full mathematical report and analysis.
* `leapfrog_2d_visualization.R`: R implementation of the leapfrog algorithm and HMC trajectory visualization on a bivariate Gaussian target.
* `vasicek_nuts_calibration.R`: Simulation of synthetic Vasicek data (using Euler-Maruyama discretization) and exact transition density modeling using NUTS via `rstan`.

## Results
The NUTS implementation successfully recovered the mean-reversion speed, long-run mean, and volatility from 250 synthetic observations. The trace plots exhibited overlapping "fuzzy caterpillar" patterns across 4 independent chains, confirming excellent mixing with the potential scale reduction factor $\hat{R} < 1.01$. The sampler efficiently navigated the highly correlated parameter subspace inherent to the Vasicek model.
