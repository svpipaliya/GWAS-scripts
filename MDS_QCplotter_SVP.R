#### Make MDS Plots
#### Usage: R CMD BATCH '--args file.mds file' ./MDS_QCplotter.R
#### Note: This script will add the .pdf extension, do not include in usage
#### Note: Change max values for i to plot as many PCs as you like

args <- commandArgs(TRUE)
pop <- read.table(args[1],header=T)

pop.CHS <- subset(pop,pop$Pop=="CHS")
pop.FIN <- subset(pop,pop$Pop=="FIN")
pop.PUR <- subset(pop,pop$Pop=="PUR")
pop.KHV <- subset(pop,pop$Pop=="KHV")
pop.ACB <- subset(pop,pop$Pop=="ACB")
pop.BEB <- subset(pop,pop$Pop=="BEB")
pop.ASW <- subset(pop,pop$Pop=="ASW")
pop.YRI <- subset(pop,pop$Pop=="YRI")
pop.LWK <- subset(pop,pop$Pop=="LWK")
pop.JPT <- subset(pop,pop$Pop=="JPT")
pop.CEU <- subset(pop,pop$Pop=="CEU")
pop.CHB <- subset(pop,pop$Pop=="CHB")
pop.CDX <- subset(pop,pop$Pop=="CDX")
pop.GIH <- subset(pop,pop$Pop=="GIH")
pop.GWD <- subset(pop,pop$Pop=="GWD")
pop.MSL <- subset(pop,pop$Pop=="MSL")
pop.ESN <- subset(pop,pop$Pop=="ESN")
pop.PJL <- subset(pop,pop$Pop=="PJL")
pop.IBS <- subset(pop,pop$Pop=="IBS")
pop.CLM <- subset(pop,pop$Pop=="CLM")
pop.PEL <- subset(pop,pop$Pop=="PEL")
pop.TSI <- subset(pop,pop$Pop=="TSI")
pop.MXL <- subset(pop,pop$Pop=="MXL")
pop.STU <- subset(pop,pop$Pop=="STU")
pop.ITU <- subset(pop,pop$Pop=="ITU")
pop.GBR <- subset(pop,pop$Pop=="GBR")
pop.TES <- subset(pop,pop$Pop=="Test")

pop.TES$Index <- seq(1,dim(pop.TES)[1])
pop.CHS$Index <- seq(max(pop.TES$Index)+1,(dim(pop.CHS)[1]+max(pop.TES$Index)))
pop.FIN$Index <- seq(max(pop.CHS$Index)+1,(dim(pop.FIN)[1]+max(pop.CEU$Index)))
pop.PUR$Index <- seq(max(pop.FIN$Index)+1,(dim(pop.PUR)[1]+max(pop.FIN$Index)))
pop.KHV$Index <- seq(max(pop.PUR$Index)+1,(dim(pop.KHV)[1]+max(pop.PUR$Index)))
pop.ACB$Index <- seq(max(pop.KHV$Index)+1,(dim(pop.ACB)[1]+max(pop.KHV$Index)))
pop.BEB$Index <- seq(max(pop.ACB$Index)+1,(dim(pop.BEB)[1]+max(pop.ACB$Index)))
pop.ASW$Index <- seq(max(pop.BEB$Index)+1,(dim(pop.ASW)[1]+max(pop.BEB$Index)))
pop.YRI$Index <- seq(max(pop.ASW$Index)+1,(dim(pop.YRI)[1]+max(pop.ASW$Index)))
pop.LWK$Index <- seq(max(pop.YRI$Index)+1,(dim(pop.LWK)[1]+max(pop.YRI$Index)))
pop.JPT$Index <- seq(max(pop.LWK$Index)+1,(dim(pop.JPT)[1]+max(pop.LWK$Index)))
pop.CEU$Index <- seq(max(pop.JPT$Index)+1,(dim(pop.CEU)[1]+max(pop.JPT$Index)))
pop.CHB$Index <- seq(max(pop.CEU$Index)+1,(dim(pop.CHB)[1]+max(pop.CEU$Index)))
pop.CDX$Index <- seq(max(pop.CHB$Index)+1,(dim(pop.CDX)[1]+max(pop.CHB$Index)))
pop.GIH$Index <- seq(max(pop.CDX$Index)+1,(dim(pop.GIH)[1]+max(pop.CDX$Index)))
pop.GWD$Index <- seq(max(pop.GIH$Index)+1,(dim(pop.GWD)[1]+max(pop.GIH$Index)))
pop.MSL$Index <- seq(max(pop.GWD$Index)+1,(dim(pop.MSL)[1]+max(pop.GWD$Index)))
pop.ESN$Index <- seq(max(pop.MSL$Index)+1,(dim(pop.ESN)[1]+max(pop.MSL$Index)))
pop.PJL$Index <- seq(max(pop.ESN$Index)+1,(dim(pop.PJL)[1]+max(pop.ESN$Index)))
pop.IBS$Index <- seq(max(pop.PJL$Index)+1,(dim(pop.IBS)[1]+max(pop.PJL$Index)))
pop.CLM$Index <- seq(max(pop.IBS$Index)+1,(dim(pop.CLM)[1]+max(pop.IBS$Index)))
pop.PEL$Index <- seq(max(pop.CLM$Index)+1,(dim(pop.PEL)[1]+max(pop.CLM$Index)))
pop.TSI$Index <- seq(max(pop.PEL$Index)+1,(dim(pop.TSI)[1]+max(pop.PEL$Index)))
pop.MXL$Index <- seq(max(pop.TSI$Index)+1,(dim(pop.MXL)[1]+max(pop.TSI$Index)))
pop.STU$Index <- seq(max(pop.MXL$Index)+1,(dim(pop.STU)[1]+max(pop.MXL$Index)))
pop.ITU$Index <- seq(max(pop.STU$Index)+1,(dim(pop.ITU)[1]+max(pop.STU$Index)))
pop.GBR$Index <- seq(max(pop.ITU$Index)+1,(dim(pop.GBR)[1]+max(pop.ITU$Index)))

for (i in 1:5){
	pdf(paste(args[2],"PC",i,".","pdf",sep=""),width=12,height=8)
	
	plot(pop.TES$Index,pop.TES[,i+1],xlim=c(0,dim(pop)[1]),ylim=c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),pch=21,col="black",bg="grey",xlab="Index",ylab=paste("PC",i,sep=""))
	points(pop.CHS$Index,pop.CHS[,i+1],pch=4,col=rgb(255,102,0,maxColorValue=255))
	points(pop.FIN$Index,pop.FIN[,i+1],pch=4,col="saddlebrown")
	points(pop.PUR$Index,pop.PUR[,i+1],pch=4,col="yellow4")
	points(pop.KHV$Index,pop.KHV[,i+1],pch=4,col="chartreuse")
	points(pop.ACB$Index,pop.ACB[,i+1],pch=4,col="limegreen")
	points(pop.ASW$Index,pop.ASW[,i+1],pch=4,col="mistyrose4")
	points(pop.YRI$Index,pop.YRI[,i+1],pch=4,col="red")
	points(pop.LWK$Index,pop.LWK[,i+1],pch=4,col="deeppink")
	points(pop.JPT$Index,pop.JPT[,i+1],pch=4,col=rgb(102,0,204,maxColorValue=255))
	points(pop.CEU$Index,pop.CEU[,i+1],pch=4,col="lightpink4") 
	points(pop.CHB$Index,pop.CHB[,i+1],pch=4,col="azure")
	points(pop.CDX$Index,pop.CDX[,i+1],pch=4,col="darkcyan") 
	points(pop.GIH$Index,pop.GIH[,i+1],pch=4,col="indianred4")
	points(pop.GWD$Index,pop.GWD[,i+1],pch=4,col="darkslategrey") 
	points(pop.MSL$Index,pop.MSL[,i+1],pch=4,col="lightcoral") 
	points(pop.ESN$Index,pop.ESN[,i+1],pch=4,col="burlywood") 
	points(pop.PJL$Index,pop.PJL[,i+1],pch=4,col="dodgerblue4") 
	points(pop.IBS$Index,pop.IBS[,i+1],pch=4,col="darkolivegreen4") 
	points(pop.CLM$Index,pop.CLM[,i+1],pch=4,col="darkorange4") 
	points(pop.PEL$Index,pop.PEL[,i+1],pch=4,col="hotpink4") 
	points(pop.TSI$Index,pop.TSI[,i+1],pch=4,col="peru") 
	points(pop.MXL$Index,pop.MXL[,i+1],pch=4,col="tan") 
	points(pop.STU$Index,pop.STU[,i+1],pch=4,col="tomato4")
	points(pop.ITU$Index,pop.ITU[,i+1],pch=4,col="palegoldenrod") 
	points(pop.GBR$Index,pop.GBR[,i+1],pch=4,col="paleturqoise4") 
	
	text(median(pop.TES$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="Sample",cex=0.8)
	text(median(pop.CHS$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="CHS",cex=0.8)
	text(median(pop.FIN$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="FIN",cex=0.8)
	text(median(pop.PUR$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="PUR",cex=0.8)
	text(median(pop.KHV$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="KHV",cex=0.8)
	text(median(pop.ACB$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="ACB",cex=0.8)
	text(median(pop.ASW$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="ASW",cex=0.8)
	text(median(pop.YRI$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="YRI",cex=0.8)
	text(median(pop.LWK$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="LWK",cex=0.8)
	text(median(pop.JPT$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="JPT",cex=0.8)
	text(median(pop.CEU$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="CEU",cex=0.8)
	text(median(pop.CHB$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="CHB",cex=0.8)
	text(median(pop.CDX$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="CDX",cex=0.8)
	text(median(pop.GIH$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="GIH",cex=0.8)
	text(median(pop.GWD$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="GWD",cex=0.8)
	text(median(pop.MSL$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="MSL",cex=0.8)
	text(median(pop.ESN$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="ESN",cex=0.8)
	text(median(pop.PJL$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="PJL",cex=0.8)
	text(median(pop.IBS$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="IBS",cex=0.8)
	text(median(pop.CLM$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="CLM",cex=0.8)
	text(median(pop.PEL$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="PEL",cex=0.8)
	text(median(pop.TSI$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="TSI",cex=0.8)
	text(median(pop.MXL$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="MXL",cex=0.8)
	text(median(pop.STU$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="STU",cex=0.8)
	text(median(pop.ITU$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="ITU",cex=0.8)
	text(median(pop.GBR$Index),min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),labels="GBR",cex=0.8)
	
	lines(c(min(pop.TES$Index),min(pop.TES$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.TES$Index),max(pop.TES$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.CHS$Index),max(pop.CHS$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.FIN$Index),max(pop.FIN$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.PUR$Index),max(pop.PUR$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.KHV$Index),max(pop.KHV$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.ACB$Index),max(pop.ACB$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.ASW$Index),max(pop.ASW$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.YRI$Index),max(pop.YRI$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.LWK$Index),max(pop.LWK$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.JPT$Index),max(pop.JPT$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.CEU$Index),max(pop.CEU$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.CHB$Index),max(pop.CHB$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.CDX$Index),max(pop.CDX$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.GIH$Index),max(pop.GIH$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.GWD$Index),max(pop.GWD$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.MSL$Index),max(pop.MSL$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.ESN$Index),max(pop.ESN$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.PJL$Index),max(pop.PJL$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.IBS$Index),max(pop.IBS$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.CLM$Index),max(pop.CLM$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.PEL$Index),max(pop.PEL$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.TSI$Index),max(pop.TSI$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.MXL$Index),max(pop.MXL$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.STU$Index),max(pop.STU$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.ITU$Index),max(pop.ITU$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	lines(c(max(pop.GBR$Index),max(pop.GBR$Index)),c(min(pop[,i+1])-0.05*(max(pop[,i+1]) - min(pop[,i+1])),max(pop[,i+1])),lty="dotted")
	
	dev.off()
}