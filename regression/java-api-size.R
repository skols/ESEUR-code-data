#
# java-api-size.R, 30 Jul 16
#
# Data from:
# A large-scale analysis of Java API usage
# Jurgen Starek
#
# Example from:
# Empirical Software Engineering using R
# Derek M. Jones


source("ESEUR_config.r")


pal_col=rainbow(5)

API=read.csv(paste0(ESEUR_dir, "regression/APINumberToProjectSizeScannerBased.csv.xz"), as.is=TRUE)

API=subset(API, Size > 0)
API$l_size=log(API$Size)

plot(API$Size, API$APIs, log="x", col=point_col,
	xlab="Lines of code", ylab="APIs")

t=loess.smooth(API$l_size, API$APIs, span=0.3)
lines(exp(t$x), t$y, col=loess_col)
#
ap_mod=glm(APIs ~ l_size, data=API, family=poisson)

pred=predict(ap_mod, newdata=data.frame(l_size=1:20), type="link", se.fit=TRUE)

lines(exp(1:20), exp(pred$fit), col=pal_col[1])
lines(exp(1:20), exp(pred$fit+1.96*pred$se.fit), col=pal_col[2])
lines(exp(1:20), exp(pred$fit-1.96*pred$se.fit), col=pal_col[2])

# A start argument is needed when link="identity" and the data contains zeros
# api_mod=glm(APIs ~ l_size+I(l_size^2), data=API, family=poisson(link="identity"),
# 		start=c(1, 1, 1))

ap_id_mod=glm(APIs ~ I(l_size^2.0), data=API, family=poisson(link="identity"),
		start=c(1, 1))

pred=predict(ap_id_mod, newdata=data.frame(l_size=1:20), type="link", se.fit=TRUE)

lines(exp(1:20), pred$fit, col=pal_col[3])
lines(exp(1:20), pred$fit+1.96*pred$se.fit, col=pal_col[2])
lines(exp(1:20), pred$fit-1.96*pred$se.fit, col=pal_col[2])

ag_mod=glm(APIs ~ I(l_size^2.0), data=API)

pred=predict(ag_mod, newdata=data.frame(l_size=1:20), type="link", se.fit=TRUE)

lines(exp(1:20), pred$fit, col=pal_col[4])
lines(exp(1:20), pred$fit+1.96*pred$se.fit, col=pal_col[2])
lines(exp(1:20), pred$fit-1.96*pred$se.fit, col=pal_col[2])

