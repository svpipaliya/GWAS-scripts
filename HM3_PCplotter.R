# READ DATA 
args <- commandArgs(TRUE)
pop <- read.table(args[1],header=T)

# DEFINE VARIABLES
pop.CEU <- subset(pop,pop$Pop=="CEU")
pop.TSI <- subset(pop,pop$Pop=="TSI")
pop.JPT_CHB <- subset(pop,pop$Pop=="JPT+CHB")
pop.CHD <- subset(pop,pop$Pop=="CHD")
pop.GIH <- subset(pop,pop$Pop=="GIH")
pop.MEX <- subset(pop,pop$Pop=="MEX")
pop.ASW <- subset(pop,pop$Pop=="ASW")
pop.LWK <- subset(pop,pop$Pop=="LWK")
pop.MKK <- subset(pop,pop$Pop=="MKK")
pop.YRI <- subset(pop,pop$Pop=="YRI")
pop.test <- subset(pop,pop$Pop=="Test")

# DETERMINE AXIS LENGTHS
maxX <- max(pop[,2])
minX <- min(pop[,2])
maxY <- max(pop[,3])*1.2
minY <- min(pop[,3])

# PLOT PC1 vs. PC2
pdf(paste(args[2],"PC1PC2.pdf",sep=""),width=6,height=6)
plot(pop.CEU[,2],pop.CEU[,3], col=("seagreen4"), xlim=c(minX, maxX), ylim=c(minY, maxY),pch=20, cex=1, xlab="PC1",ylab="PC2", font.lab=2,cex.lab=1)
points(pop.GIH[,2],pop.GIH[,3], col=("palegreen2"),pch=20, cex=0.5)
points(pop.MEX[,2],pop.MEX[,3], col=("seagreen3"),pch=20, cex=0.5)
points(pop.TSI[,2],pop.TSI[,3], col=("yellowgreen"),pch=20, cex=0.5)
points(pop.YRI[,2],pop.YRI[,3], col=("darkblue"),pch=20, cex=1)
points(pop.ASW[,2],pop.ASW[,3], col=("steelblue1"),pch=20, cex=0.5)
points(pop.LWK[,2],pop.LWK[,3], col=("slategray1"),pch=20, cex=0.5)
points(pop.MKK[,2],pop.MKK[,3], col=("steelblue"),pch=20, cex=0.5)
points(pop.JPT_CHB[,2],pop.JPT_CHB[,3], col=("tomato3"),pch=20, cex=1)
points(pop.CHD[,2],pop.CHD[,3], col=("sienna1"),pch=20, cex=0.5)
points(pop.test[,2],pop.test[,3],col="black",pch=4,cex=1)
legend("topleft", legend = c("CEU","GIH","MEX","TSI","YRI","ASW","LWK","MKK","JPT+CHB","CHD","Sample"), col=c("seagreen4", "palegreen2", "seagreen3", "yellowgreen","darkblue","steelblue1","slategray1","steelblue","tomato3","sienna1","black"), ncol=3, pch=20, bty='n', cex=1)
dev.off()

# PLOT PC1 vs. PC3
pdf(paste(args[2],"PC1PC3.pdf",sep=""),width=6,height=6)
maxY <- max(pop[,4])
minY <- min(pop[,4])*1.2
plot(pop.CEU[,2],pop.CEU[,4], col=("seagreen4"), xlim=c(minX, maxX), ylim=c(minY, maxY),pch=20, cex=1, xlab="PC1",ylab="PC3", font.lab=2,cex.lab=1)
points(pop.GIH[,2],pop.GIH[,4], col=("palegreen2"),pch=20, cex=0.5)
points(pop.MEX[,2],pop.MEX[,4], col=("seagreen3"),pch=20, cex=0.5)
points(pop.TSI[,2],pop.TSI[,4], col=("yellowgreen"),pch=20, cex=0.5)
points(pop.YRI[,2],pop.YRI[,4], col=("darkblue"),pch=20, cex=1)
points(pop.ASW[,2],pop.ASW[,4], col=("steelblue1"),pch=20, cex=0.5)
points(pop.LWK[,2],pop.LWK[,4], col=("slategray1"),pch=20, cex=0.5)
points(pop.MKK[,2],pop.MKK[,4], col=("steelblue"),pch=20, cex=0.5)
points(pop.JPT_CHB[,2],pop.JPT_CHB[,4], col=("tomato3"),pch=20, cex=1)
points(pop.CHD[,2],pop.CHD[,4], col=("sienna1"),pch=20, cex=0.5)
points(pop.test[,2],pop.test[,4],col="black",pch=4,cex=1)
legend("bottomright", legend = c("CEU","GIH","MEX","TSI","YRI","ASW","LWK","MKK","JPT+CHB","CHD","Sample"), col=c("seagreen4", "palegreen2", "seagreen3", "yellowgreen","darkblue","steelblue1","slategray1","steelblue","tomato3","sienna1","black"), ncol=3, pch=20, bty='n', cex=1)
dev.off()


