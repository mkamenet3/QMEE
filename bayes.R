set.seed(411)

N <- 40

## predictor variables
a <- runif(N)
b <- runif(N)
c <- runif(N)
y <- rnorm(N,mean=a+4*b+c,sd=1)
dat <- data.frame(y,a,b,c)

print(summary(dat))
summary(lm(y~a+b+c,data=dat))
library("R2jags")
jags1 <- jags(model.file='bayes.bug',
              parameters=c("ma","mb","mc","int"),
              data = list('a' = a, 'b' = b, 'c' = c, 'N'=N, 'y'=y),
              n.chains = 4,
              inits=NULL)
```

- You can use `inits=NULL` to have JAGS pick the initial values randomly from the priors. For more complex models you might want to pick starting values for the chains yourself (see the `?jags` documentation).

### Examine the chains and output

``` {r coda2.R, echo=TRUE}
library(R2jags)
library(coda)
library(emdbook)    ## for lump.mcmc.list() and as.mcmc.bugs()
library(arm)        ## for coefplot
library(lattice)
library(dotwhisker)
library(ggplot2); theme_set(theme_bw())
bb <- jags1$BUGSoutput  ## extract the "BUGS output" component
mm <- as.mcmc.bugs(bb)  ## convert it to an "mcmc" object that coda can handle
plot(jags1)             ## large-format graph
## plot(mm)                ## trace + density plots, same as above
xyplot(mm,layout=c(2,3))  ## prettier trace plot
densityplot(mm,layout=c(2,3)) ## prettier density plot
print(dwplot(jags1))              ## estimate + credible interval plot
```

The `lump.mcmc.list` function from the `emdbook` package can be useful for converting a set of MCMC chains into a single long chain.

## Further notes

### Categorical variables

Implementing models with categorical variables (say, a t-test or an ANOVA) is a little bit more tedious than the multiple regression analysis shown above.  There are two basic strategies:

- pass the categorical variable as a vector of numeric codes (i.e. pass `as.numeric(f)` rather than `f` to JAGS in your `data` list), and make your parameters a simple vector of the means corresponding to each level, e.g. you could have a vector of parameters `catparam` and specify the predicted value as `pred[i] = catparam[f[i]]`
- construct a design matrix using the `model.matrix` function in R and pass the whole model matrix (`X`)to JAGS.  Then, to get the predicted value for each observation, just add up the relevant columns of the model matrix: e.g. `pred[i] = beta[1]*X[i,1]+beta[2]*X[i,2]+beta[3]*X[i,3]`.  You can also use the built-in `inprod` (inner product) function: `pred[i] = inprod(X[i,],beta)`

The second approach is a little bit harder to understand but generalizes to more complicated situations, and gives you answers that will more closely match the analogous analyses in R (e.g. using `lm`).

### Built-in Bayesian modeling techniques

- `bayesglm` from the `arm` package

``` {r coda3.R, echo=FALSE,message=FALSE}
library('coda')
library('emdbook')    ## for lump.mcmc.list() and as.mcmc.bugs()
library('lattice')
mmL <- emdbook::lump.mcmc.list(mm)  ## convert to a single long chain
colMeans(mmL)   ## which one is biggest? b ...
## test the probability that it is really the biggest
mean((mmL[,"mb"] > mmL[,"ma"]) & (mmL[,"mb"] > mmL[,"mc"]))
## or (alternatively -- this would be good if you had lots of categories)
meanschain <- mmL[,-(1:2)]
maxval <- apply(meanschain,1,which.max)
mean(maxval==2)
```
