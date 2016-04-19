# Loading required packages

library(ggplot2)
library(GGally)
library(dplyr)
library(MASS)
library(car)
library(glmulti)
library(memisc)
library(Hmisc)
library(gridExtra)
library(stargazer)
library(plot3D)

# Loading and preparing data for analysis
data(mtcars)
## Tranforming variables to the factor and using readable levels
toFactor <- c("cyl","gear", "carb", "vs", "am")
dfCars <- tbl_df(mtcars) %>% mutate_each_(funs(factor), toFactor)

levels(dfCars$am) <- c("automatic", "manual")
levels(dfCars$vs) <- c("V", "S")

# Fitting models


## am and wt are highly correlated, so we include their ijteraction in a new model
fitBICI <- lm(mpg ~ wt + qsec + am + wt*am, dfCars)
coefBICI <- coef(fitBICI)

transmission <- c("manual", "automatic")
intercept <- c(coefBICI[1] + coefBICI[4], coefBICI[1])
wt <- c(coefBICI[2] + coefBICI[5], coefBICI[2])
qsec <- c(coefBICI[3], coefBICI[3])
coefDf <- data.frame(transmission, intercept, wt, qsec)

# wt where Manual becomes worse than Automatic
equalMpg <- (coefDf[2,2] - coefDf[1,2]) / (coefDf[1,3] - coefDf[2,3])

# Pair comparison of  Selected Model variables",
myGgpairs <- function () {
        plot <- ggpairs(dfCars, columns = c("mpg","wt", "qsec", "am"),
                 mapping = aes(alpha =0.4),
                 lower = list(continuous = "cor", mapping = aes(colour = am)),
                 upper = list(continuous = "smooth", mapping = aes(colour = am)),
                 title = "Pair Comparison (selected model variables)")
        plot
}

ManVsAuto <- function(data, xaxis, prediction) {
    plot <- ggplot(data, aes_string(x = xaxis, y = "mpg")) +
        geom_point(aes_string(colour = "am", 
                              size = ifelse(xaxis == "wt", "qsec", "wt")),
                   alpha = .4) +
        geom_hline(yintercept = prediction, col="black", size = 1.5)
        if (xaxis == "wt") {
        plot <- plot + geom_vline(xintercept = equalMpg, col="black", linetype="dashed")
        }
    plot
}


ggResid <- function(model, data) {
residBIC <- fortify(model, data)

# Which = 1
residPlot1 <- ggplot(model, aes(.fitted, .resid)) +
    geom_hline(yintercept = 0, col="red", linetype="dashed") +
    geom_point(alpha=0.4) +
    geom_smooth(se = F) +
    xlab("Fitted values") + ylab("Residuals") + 
    ggtitle("Residual vs Fitted Plot") + theme_bw()

# Which = 2
residPlot2 <- ggplot(model, aes(sample = .stdresid)) +
    stat_qq(alpha=0.4) +
    geom_abline() +
    xlab("Theoretical Quantiles") + ylab("Standardized Residuals") +
    ggtitle("Normal Q-Q") + theme_bw()

# Which = 3
residPlot3 <- ggplot(model, aes(.fitted, sqrt(abs(.stdresid)))) +
    geom_point(alpha=0.4) +
    geom_smooth(se = FALSE) +
    xlab("Fitted Value") + ylab(expression(sqrt("|Standardized residuals|"))) +
    ggtitle("Scale-Location")+theme_bw()
    

# Which = 4
residPlot4 <- ggplot(model, aes(seq_along(.cooksd), .cooksd)) +
    geom_bar(stat = "identity") +
    xlab("Obs. Number")+ylab("Cook's distance") +
    ggtitle("Cook's distance") + theme_bw()

# Which = 5
residPlot5 <- ggplot(model, aes(.hat, .stdresid)) +
    geom_vline(size = 2, colour = "white", xintercept = 0) +
    geom_hline(size = 2, colour = "white", yintercept = 0) +
    geom_point(alpha=0.4) +
    geom_smooth(se = FALSE) +
    xlab("Leverage") + ylab("Standardized Residuals") +
    ggtitle("Residual vs Leverage Plot") + 
    theme_bw() + theme(legend.position="bottom") +
    scale_size_continuous("Cook's Distance", range=c(1,5))
    

# Which = 6
residPlot6 <- ggplot(model, aes(.hat, .cooksd)) +
    geom_vline(xintercept = 0, colour = NA) +
    geom_abline(slope = seq(0, 3, by = 0.5), colour = "grey", linetype="dashed") +
    geom_smooth(se = FALSE) +
    geom_point(alpha=0.4) +
    xlab("Leverage hii") + ylab("Cook's Distance") +
    ggtitle("Cook's dist vs Leverage hii/(1-hii)") + theme_bw()

grid.arrange(residPlot1, residPlot2, residPlot3, residPlot4, residPlot5, residPlot6, 
             ncol = 3, nrow=2)
}

