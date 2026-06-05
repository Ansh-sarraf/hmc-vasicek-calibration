#---------------------------------------------------------
# HMC TRAJECTORY VISUALIZATION
#---------------------------------------------------------

# Load required library
library(ggplot2)

# Define the target distribution (Negative Log-Posterior / Potential Energy)
# For a standard 2D Gaussian: U(x) = 0.5 * (x1^2 + x2^2)
grad_U <- function(q) {
  return(q) # Derivative of 0.5 * q^2 is q
}

# Leapfrog Algorithm
leapfrog <- function(q, p, epsilon, L) {
  q_path <- matrix(NA, nrow = L + 1, ncol = 2)
  q_path[1, ] <- q
  
  p <- p - epsilon * grad_U(q) / 2
  for (i in 1:L) {
    q <- q + epsilon * p
    q_path[i + 1, ] <- q
    if (i != L) p <- p - epsilon * grad_U(q)
  }
  p <- p - epsilon * grad_U(q) / 2
  return(q_path)
}

# Initial states
q_init <- c(-2, 2)  # Starting position
p_init <- c(1, 0.5) # Initial random momentum
epsilon <- 0.15     # Step size
L <- 40             # Number of leapfrog steps

# Generate trajectory
path <- leapfrog(q_init, p_init, epsilon, L)
path_df <- data.frame(x = path[,1], y = path[,2], step = 1:(L+1))

# Generate grid for contour plot
grid_vals <- seq(-3, 3, length.out = 100)
grid <- expand.grid(x = grid_vals, y = grid_vals)
grid$z <- exp(-0.5 * (grid$x^2 + grid$y^2)) # PDF of 2D Gaussian

# Plot using ggplot2
ggplot() +
  geom_contour_filled(data = grid, aes(x = x, y = y, z = z), alpha = 0.8) +
  geom_path(data = path_df, aes(x = x, y = y), color = "red", size = 1, arrow = arrow(length = unit(0.15, "cm"))) +
  geom_point(data = path_df[1,], aes(x = x, y = y), color = "yellow", size = 4) +
  geom_point(data = path_df[nrow(path_df),], aes(x = x, y = y), color = "cyan", size = 4) +
  labs(title = "HMC Leapfrog Trajectory on 2D Target Distribution",
       subtitle = "Yellow = Start, Cyan = End",
       x = "x1", y = "x2") +
  theme_minimal() +
  scale_fill_viridis_d(option = "magma") +
  theme(legend.position = "none")

