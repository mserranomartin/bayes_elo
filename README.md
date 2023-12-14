Sea $X_i$ la variable aleatoria que representa la performance de un jugador $i$ . Suponemos *a priori* que se distribuye como una normal $\pi_i \sim \mathcal N(\mu_i, \sigma_i)$. Sean también las variables $Y_{ij}$ que representan el resultado de un enfrentamiento entre los jugadores $i$ y $j$

$$
Y_{ij} = \begin{cases}
1 & \text{ si } X_i \geq X_j\\
0 & \text{ si } X_i < X_j
\end{cases},
$$

decartando el empate.

Queremos actualizar nuestro conocimiento de $X_i$ tras observar el resultado de una partida, es decir, buscamos $\pi_i(\cdot\ |\ y_{ij})$. Por la regla de Bayes obtenemos:

$$
\pi_i(x_i \ |\ y_{ij}) = \frac{\mathbb P(Y_{ij} = y_{ij} \ | \ X_i = x_i)}{\mathbb P(Y_{ij} = y_{ij})}\pi_i(x_i) = \begin{cases}
\frac{\mathbb P(X_j < x_i)}{p_{ij}}\pi_i(x_i) & \text{ si } y_{ij} = 1\\
\frac{1-\mathbb P(X_j < x_i)}{1-p_{ij}}\pi_i(x_i) & \text{ si } y_{ij} = 0
\end{cases}
$$

Un código en R para calcularlo es el siguiente:

```r
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
```

Por ejemplo, para $\mu_1 = 0, \mu_2 = 3, \sigma_1 = \sigma_2 = 1$ obtenemos los siguientes gráficos que marcan las distribuciones a posteriori (en línea continua) para el jugador 1 (colores rojos) y el jugador 2 (colores azules) donde se observa que ambas medias cambian mucho si el resultado se aleja de lo esperable, pero los jugadores no son penalizados o recompensados en exceso si gana el fuerte y pierde el débil.

El siguiente gráfico muestra las distribuciones gana el jugador 1 ($\mu_1 = 1.75, \mu_2 = 1.25$). Obsevamos el desplazamiento de la media es igual para ambos (fruto de la igual varianza). Lo mismo ocurre cuando gana el jugador 2  ($\mu_1 = -0.03, \mu_2 = 3.03$).
![Pasted image 20231116180946](https://github.com/mserranomartin/bayes_elo/assets/63246434/fb66ecb7-972a-45de-b9cd-c2f2d99b2e44)


Los dos siguientes son las comparaciones de las distribuciones de victoria y derrota para cada jugador:
![Pasted image 20231116180042](https://github.com/mserranomartin/bayes_elo/assets/63246434/83e94ec2-47cb-40c1-9182-14a3deb9b178)
![Pasted image 20231116174744](https://github.com/mserranomartin/bayes_elo/assets/63246434/622a506c-67b9-4b06-94c4-b957ae330091)

Experimentando con los valores de la varianza obtenemos cambios más interesantes.
