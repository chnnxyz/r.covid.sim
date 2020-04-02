# Stochastic and Deterministic SIR models with birth/death dynamics
## Contents
sdecovid.R is a **general script for simulating pandemics** with SIR and stochastic SIR. Further information regarding stochastic SIR/SIS can be found in the following link:

https://epubs.siam.org/doi/10.1137/10081856X - A. Gray, D. Greenhalgh, L. Hu, X. Mao, and J. Pan - *A Stochastic Differential Equation SIS model*

## Model
### System of Equations
<img src="https://render.githubusercontent.com/render/math?math=\frac{dS}{dt}=-\frac{\beta SI}{N}%2B(\lambda-\mu)S">

<img src="https://render.githubusercontent.com/render/math?math=\frac{dI}{dt}=\frac{\beta SI}{N}-(\gamma%2B\mu)I">

<img src="https://render.githubusercontent.com/render/math?math=\frac{dS}{dt}=\gamma I-\mu R">

### Variables
<img src="https://render.githubusercontent.com/render/math?math=S=S(t)">: Susceptible population

<img src="https://render.githubusercontent.com/render/math?math=I=I(t)">: Infected population

<img src="https://render.githubusercontent.com/render/math?math=R=R(t)">: Recovered and dead by illness population

<img src="https://render.githubusercontent.com/render/math?math=\beta">: Infection probability

<img src="https://render.githubusercontent.com/render/math?math=\gamma">: Recovery rate

<img src="https://render.githubusercontent.com/render/math?math=N">: Total population

<img src="https://render.githubusercontent.com/render/math?math=\lambda">: Population's birth rate (percentual, daily)

<img src="https://render.githubusercontent.com/render/math?math=\mu">: Population's death rate (percentual, daily)

### Stochastic considerations

<img src="https://render.githubusercontent.com/render/math?math=\tilde{\beta}dt=\beta dt\%2B\sigma_\beta dW_t">

<img src="https://render.githubusercontent.com/render/math?math=\tilde{\gamma}dt=\beta dt\%2B\sigma_\gamma dW_t">

Where <img src="https://render.githubusercontent.com/render/math?math=W_t"> is a Standard Wiener Process

## Needed data

It will be necessary to obtain a distribution of recovery times, fatality rates and infection probability in order to properly address COVID-19. If you have access to any of this information, feel free to contribute or email me.
