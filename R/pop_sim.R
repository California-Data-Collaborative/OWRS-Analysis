

reference_date <- as.Date("2017-07-15")
supplier_reports <- read.csv('data/supplier_report.csv', stringsAsFactors=FALSE) %>%
  filter(report_date == reference_date)



# utility population
N <- 160721  
# GPCD
gpcd <- 114.576 
# residential production as total production times percent residential
res_production_gal <- 0.691*826131123  
# assume a standard deviation for the distribution
stddev <- 2 

# Generate synthetic population of daily water use
samples <- rlnorm(N, meanlog=log(gpcd), sdlog = log(stddev) ) * rbernoulli(N, p=0.95)

# using the GPCD as the mean of the Lognormal doesn't seem to result in accurate aggregate numbers
# This is probably due to an incorrect distributional assumption, so for now we do a manual correction
# by scaling all samples such that the total is accurate 
corrected_samples <- samples/(31*sum(samples)/res_production_gal)

# Look at output
hist(samples, breaks=100)
(sum(samples)/N)/gpcd
31*sum(samples)/res_production_gal
