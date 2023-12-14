#### Libraries ####

library(ggplot2)

#### Parameters ####
mu1 <- 0
mu2 <- 3
sigma1 = sigma2 <- 1

#### Code ####

# Compute the posterior
p <- integrate(f = \(x) dnorm(x, mu2, sigma2) *(1- pnorm(x, mu1, sigma1)),
               lower = -Inf, upper = +Inf)$value
f1.post.win <- \(x) dnorm(x, mu1, sigma1) * pnorm(x, mu2, sigma2) / p
mu1.post.win <- integrate(\(x) x * f1.post.win(x), 
                          lower = -Inf, upper = Inf)$value

f1.post.lose <- \(x) dnorm(x, mu1, sigma1) * (1 - pnorm(x, mu2, sigma2) )/(1-p)
mu1.post.lose <- integrate(\(x) x * f1.post.lose(x),
                           lower = -Inf, upper = Inf)$value

# Plot  
ggplot2::ggplot() + 
  xlim(min(mu1-2*sigma1, mu2 - 2*sigma2),
       max(mu1+2*sigma1, mu2 + 2*sigma2)) + 
  geom_function(fun = f1.post.win, color = '#ff0033', linetype = 1) + 
    geom_vline(xintercept = mu1.post.win, color = '#ff0033', linetype = 3) +
  geom_function(fun = f1.post.lose, color = '#990000', linetype = 1) + 
    geom_vline(xintercept = mu1.post.lose, color = '#990000', linetype = 3) +
  geom_function(fun = \(x) dnorm(x, mu1, sigma1), 
                color = '#ff6666', linetype = 2) +
  geom_function(fun = \(x) dnorm(x, mu2, sigma2), 
                color = 'steelblue', linetype = 2) +
  xlab('x')
