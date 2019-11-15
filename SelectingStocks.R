#loading libraries
library(gdata)
library(tm)
library(stringr)
library(dplyr)
library(plyr)
library(tidyr)

## Load the Fundamental Data file
dat = read.csv('/path/output-semicolon-narrow.csv', sep = ';', header = 1)

#Loading the tickers of communciation industry
tickers = as.character(read.xls("/path/tickers.xlsx", sheet = 1)[,'Ticker'])
## Removing Excess words to get Actual Tickers
tickers = removeWords(tickers, " US Equity")

q_year = stringr::str_split_fixed(dat$period, '-',2)

##Get the quarters from period column
dat$quarter = q_year[,1]
dat$year = q_year[,2]

#Dropping the previous period column
dat = subset(dat, select = -(period))

#Selecting only the year-end data of Communication's Industry
com_dat = filter(dat, Ticker %in% tickers & quarter == 'Q4')

#Calculated Ratios
com_dat = ddply(com_dat, c('Ticker', 'Indicator.Name'),transform, Growth_Rate = (Indicator.Value - lag(Indicator.Value))/ abs(lag(Indicator.Value)))

g_ratios = c('Net Profit', 'Return on Assets', 'Total Assets', 'Revenues', 'Gross Margin')
growth = vector()
growth = NULL

#Calculating growth ratios
for (i in g_ratios){
  g = filter(com_dat, Indicator.Name == i)
  g$Indicator.Name = paste(i,'growth', sep = '-')
  g$Indicator.Value = g$Growth_Rate
  growth = rbind.fill(growth, g)
}

growth = subset(growth, select = -Growth_Rate)
com_dat = rbind.fill(com_dat, growth)

#Ratios that we need from this fundamental data
ratios = c('Return on Assets', 'Gross Margin', 'Operating Margin', 'Net Profit Margin', 'Net Profit-growth', 'Return on Assets-growth' ,'Total Assets-growth', 'Revenues-growth',
           'Gross Margin-growth','Current Ratio', 'Debt to Assets Ratio' )

f_com_dat = filter(com_dat, Indicator.Name %in% ratios)

ticker_w = unique(f_com_dat$Ticker)

#Ratios for each company over the years
out = vector()
out = NULL
for (ticker in ticker_w){
  for (indicator in ratios){
    n = filter(f_com_dat, Ticker == ticker & Indicator.Name == indicator)
    n = n[,c('Ticker', 'Indicator.Name', 'year', 'Indicator.Value') ]
    nn = n %>% spread(key = year, value = Indicator.Value)
    out = rbind.fill(out,nn)
  }
  }
out = out[c(1,2,13,12,3,4,5,6,7,8,9,10,11)]

f_ratios = unique(out$Indicator.Name)

#Ranking of the companies based on sample selected
ranks_r = vector()
ranks_r = NULL
for (i in f_ratios){
  ranks = filter(out, Indicator.Name == i) %>% select('Ticker','Indicator.Name')
  for (j in as.character(c(2008:2018))){
    if (i != 'Debt to Assets Ratio'){
      t = filter(out, Indicator.Name == i) %>% select('Ticker','Indicator.Name', j)
      t[paste('Rank',j,sep = '-')] = rank(t[j], na.last = "keep")
      t = t[paste('Rank',j,sep = '-')]
      ranks =cbind(ranks,t)
    }
    else
    {
      t = filter(out, Indicator.Name == i) %>% select('Ticker','Indicator.Name', j)
      t[paste('Rank',j,sep = '-')] = rank(-t[j], na.last = "keep")
      t = t[paste('Rank',j,sep = '-')]
      ranks =cbind(ranks,t)
    }
    }
  ranks_r = rbind(ranks_r,ranks)
}

#Rank Score Summation for each company
final_score = ranks_r %>% select(-Indicator.Name) %>% group_by(Ticker) %>% summarise_all(funs(sum), na.rm = TRUE)

#Selecting the Best firm based on total ranking score final_score
a_firms = data.frame(matrix( nrow = 1, ncol = 1))
for (q in as.character(c(2008:2018))){
  p = final_score[final_score[paste('Rank',q,sep = '-')]==max(final_score[paste('Rank',q,sep = '-')]),1]
  p = data.frame(p)
  colnames(p) <- q
  a_firms = cbind(a_firms, p)
}

write.csv(a_firms[-1], file = 'Anchors.csv', row.names = FALSE)
