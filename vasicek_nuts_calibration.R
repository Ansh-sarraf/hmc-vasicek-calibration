library(rstan)

# 1. Simulate some fake interest rate data using the Vasicek model
set.seed(42)
N <- 250
dt <- 1/252 # Daily data
a_true <- 0.5
b_true <- 0.05
sigma_true <- 0.02
r <- numeric(N)
r[1] <- 0.04

for (t in 2:N) {
  dr <- a_true * (b_true - r[t-1]) * dt + sigma_true * sqrt(dt) * rnorm(1)
  r[t] <- r[t-1] + dr
}

stan_data <- list(N = N, dt = dt, r = r)

# 2. Define the Stan Model (Uses exact transition density of Vasicek)
stan_code <- "
data {
  int<lower=1> N;
  real dt;
  vector[N] r;
}
parameters {
  real<lower=0> a;
  real<lower=0> b;
  real<lower=0> sigma;
}
model {
  // Priors
  a ~ normal(0, 2);
  b ~ normal(0.05, 0.05);
  sigma ~ cauchy(0, 0.1);
  
  // Vasicek exact transition density
  for (t in 2:N) {
    real mean_r = r[t-1] * exp(-a * dt) + b * (1 - exp(-a * dt));
    real var_r = (square(sigma) / (2 * a)) * (1 - exp(-2 * a * dt));
    r[t] ~ normal(mean_r, sqrt(var_r));
  }
}
"

# 3. Run HMC (NUTS) via rstan
fit <- stan(model_code = stan_code, data = stan_data, 
            iter = 2000, chains = 4, seed = 123)

# 4. Generate trace plot to show HMC mixing
traceplot(fit, pars = c("a", "b", "sigma"), inc_warmup = FALSE)



library(rstan)

# I'm going to simulate some dummy interest rate data first using the Vasicek model
set.seed(42)
N <- 250
dt <- 1/252 # Setting this up for daily data
a_true <- 0.5
b_true <- 0.05
sigma_true <- 0.02
r <- numeric(N)
r[1] <- 0.04

for (t in 2:N) {
  dr <- a_true * (b_true - r[t-1]) * dt + sigma_true * sqrt(dt) * rnorm(1)
  r[t] <- r[t-1] + dr
}

stan_data <- list(N = N, dt = dt, r = r)

# Writing out my Stan model. I decided to use the exact transition density for Vasicek here.
stan_code <- "
data {
  int<lower=1> N;
  real dt;
  vector[N] r;
}
parameters {
  real<lower=0> a;
  real<lower=0> b;
  real<lower=0> sigma;
}
model {
  // Defining my priors
  a ~ normal(0, 2);
  b ~ normal(0.05, 0.05);
  sigma ~ cauchy(0, 0.1);
  
  // Applying the exact transition density for the model
  for (t in 2:N) {
    real mean_r = r[t-1] * exp(-a * dt) + b * (1 - exp(-a * dt));
    real var_r = (square(sigma) / (2 * a)) * (1 - exp(-2 * a * dt));
    r[t] ~ normal(mean_r, sqrt(var_r));
  }
}
"

# Firing up rstan to run HMC and sample the posterior
fit <- stan(model_code = stan_code, data = stan_data, 
            iter = 2000, chains = 4, seed = 123)

# Checking the trace plots to make sure my chains are mixing properly
traceplot(fit, pars = c("a", "b", "sigma"), inc_warmup = FALSE)