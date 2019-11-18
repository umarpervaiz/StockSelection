#Start for   loop
for (i in ind){
  ind_dat = dat[dat$Company.Industry.Classification.Code == i & dat$quarter == "Q4",]
  ind_dat = ddply(ind_dat, c('Ticker', 'Indicator.Name'),transform, Growth_Rate = (Indicator.Value - lag(Indicator.Value))/ abs(lag(Indicator.Value)))
  
  g_ratios = c('Net Profit', 'Return on Assets', 'Total Assets', 'Revenues', 'Gross Margin')
  growth = vector()
  growth = NULL
  
  for (k in g_ratios){
    g = filter(ind_dat, Indicator.Name == k)
    if (nrow(g) ==0) next
    g$Indicator.Name = paste(k,'growth', sep = '-')
    g$Indicator.Value = g$Growth_Rate
    growth = rbind.fill(growth, g)
  }
  growth = subset(growth, select = -Growth_Rate)
  com_dat = rbind.fill(ind_dat, growth)
  
  ratios = c('Return on Assets', 'Gross Margin', 'Operating Margin', 'Net Profit Margin', 'Net Profit-growth', 'Return on Assets-growth' ,'Total Assets-growth', 'Revenues-growth', 'Gross Margin-growth','Current Ratio', 'Debt to Assets Ratio' )
  
  
  f_com_dat = filter(ind_dat, Indicator.Name %in% ratios)
  
  ticker_w = unique(f_com_dat$Ticker)
  out = vector()
  out = NULL
  
  for (ticker in ticker_w){
    for (indicator in ratios){
      n = filter(f_com_dat, Ticker == ticker & Indicator.Name == indicator)
      n = n[,c('Ticker', 'Indicator.Name', 'year', 'Indicator.Value') ]
      n = n%>% distinct(year, .keep_all = TRUE)
      nn = n %>% spread(key = year, value = Indicator.Value)
      out = rbind.fill(out,nn)
    }
  }
  
  out = out[c("Ticker", "Indicator.Name", sort(colnames(out[,-c(1,2)])))]
  
  f_ratios = unique(out$Indicator.Name)
  
  ranks_r = vector()
  ranks_r = NULL
  
  for (r in f_ratios){
    ranks = filter(out, Indicator.Name == r) %>% select('Ticker','Indicator.Name')
    for (y in as.character(c(2008:2018))){
      if (r != 'Debt to Assets Ratio'){
        t = filter(out, Indicator.Name == r) %>% select('Ticker','Indicator.Name', y)
        t[paste('Rank',y,sep = '-')] = rank(t[y], na.last = "keep")
        t = t[paste('Rank',y,sep = '-')]
        ranks =cbind(ranks,t)
      }
      else
      {
        t = filter(out, Indicator.Name == r) %>% select('Ticker','Indicator.Name', y)
        t[paste('Rank',y,sep = '-')] = rank(-t[y], na.last = "keep")
        t = t[paste('Rank',y,sep = '-')]
        ranks =cbind(ranks,t)
      }
    }
    ranks_r = rbind(ranks_r,ranks)
  }
  
  final_score = ranks_r %>% select(-Indicator.Name) %>% group_by(Ticker) %>% summarise_all(funs(sum), na.rm = TRUE)
  
  a_firms = data.frame(matrix( nrow = 1, ncol = 1))
  for (q in as.character(c(2008:2018))){
    p = final_score[final_score[paste('Rank',q,sep = '-')]==max(final_score[paste('Rank',q,sep = '-')]),1]
    p = data.frame(p)
    colnames(p) <- q
    a_firms = cbind(a_firms, p)
  }
  write.csv(a_firms[-1], file = paste(i,'Anchors.csv', sep = ""), row.names = FALSE)
}

##Loop end