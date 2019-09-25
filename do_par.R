library(foreach)
library(parallel)

#simple example:
testlist = list(1:5, 6:10, 11:15)

test = foreach(b=testlist) %do%{
  b^2
}

test

####        Notes: 
#with each r session you create there is a Master process
#Normally with computing, there is one process. However, what we want to do is 
#create two worker processes. 

#The master creates sub worker processes within R. 
#These sub worker processes are called cores. 

#'foreach' is great because it is able to pass specific objects to worker procceses.

#Each worker processes is allocated a "core" (processor on a computer)
#We allocate jobs ("worker processes") - and those jobs ("worker processes") are sent to computers ("cores")

#the foreach & do loop will then create a regular forloop

#the foreach & dopar loop will then send each iteration to each core. 
#the result from the dopar loop will then get sent back to the master R





#one example: 
test= foreach(subvec = testlist, .combine=rbind) %dopar%{
  #foreach vector within the list: dopar an rbind
  res=rep(0,length(subvec))
  #create an empty vector of 0s
  for (i in 1:length(subvec)){
    res[i] = subvec[i]^2
    #regular R code that includes what computation you want to do
  }
  res
  #return the data
}


#test = foreach(subvec = testlist) %dopar%{
#f2(subvec)
#}

#do.call(rbind.fill, test)

#try with 10 cores

#paralellize
cl = parallel::makeCluster(2) #two clusters for two worker processes

test = foreach(b = 1:length(testlist)) %dopar% { #%dopar% will parallelize it
  fname = paste('chunk', b, '.RDS', sep = '')
  dat = readRDS(fname)
  nd = rbind(dat, testlist[[b]])
  saveRDS(nd, fname)
}


readRDS('chunk1.RDS')

parallel::stopCluster(cl)

readRDS('1.RDS')
