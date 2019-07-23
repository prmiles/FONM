# FONM

Fractional Order Numerical Methods

In this project we consider various quadrature methods that can be used in approximating the Riemann-Liouville fractional derivative operator.  For more details regarding fractional order methods and their definitions, see the paper by [Mashayekhi et. al.](1).  The following methods have been implemented for approximating the fractional derivative

- Grunwald-Letnikov (GL)
- Riemann-Sum (RS)
- Gaussian Quadrature (GQ)
- Gauss-Laguerre Quadrature (GLQ)

Preliminary analysis of different combinations of these approaches led to the conference proceeding by [Miles et. al.](2), where the following observations were made with respect to a nonlinear viscoelastic model.  It is observed in the table that the optimal computational performance is achieved when combining Gaussian Quadrature (GQ) with the Riemann-Sum (RS) approximation.

| Method | Rel. Err. | CPU Time (sec) |
| ------ | :--------:| --------------:|
| GL | - | 1.19 |
| RS | 1.88e-1 | 1.13 |
| GQRS | 2.05e-1 | 0.27 |
| GQGL | 1.09e-1 | 1.63 |

### References
[1](https://www.sciencedirect.com/science/article/pii/S0022509617304428). Mashayekhi, Somayeh, Paul Miles, M. Yousuff Hussaini, and William S. Oates. "Fractional viscoelasticity in fractal and non-fractal media: Theory, experimental validation, and uncertainty analysis." Journal of the Mechanics and Physics of Solids 111 (2018): 134-156.

[2](). Paul Miles, Graham Pash, William Oates, Ralph C. Smith. "Numerical Techniques to Model Fractional-Order Nonlinear Viscoelasticity in Soft Elastomers." ASME Smart Materials, Adaptive Structures, and Intelligent Systems, 2018.  _Pending_
