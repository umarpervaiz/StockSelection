# StockSelection

### (2008 - 2018) Selected Stocks from each industry realized 11.029245 % return per annum in the year subsequent to their prediction, this return outpassed S&P500 by 2.2829 %, and the Industry Average by 5.6494% 

### Our selected stocks for each industry had positive return (average of prediction-subsequent year return over period (2008-2018)) for 44 (80% of the time) out of our sample of 55 Industries

We used https://simfin.com/ for the data on fundamentals for the companies in 55 indutries (Sample Set) over the time period of 2008 - 2018. 

Consider telecommunication industry to walk through the process,

##### Companies in Telecommunication
ALSK (Alaska Communications)

CBB (Cincinnati Bell Inc.)

CNSL (Consolidated Communications Holdings, Inc.)

CTL (CenturyLink)

EGHT (8x8, Inc.)

FTR (Frontier Communications Corp)

HCHC (HC2 Holdings)

IDT (Integrated Device Technology, Inc)

S (Sprint Corporation)

T (AT&T)

TMUS (T-Mobile US)

VZ (Verizon Communications)

ZAYO (Zayo Group Holdings)

### Based on the paper "Combined soft computing model for value stock selection based on fundamental analysis" we choose the ratios

##### Ratios included for ranking stocks (11 in total)

Return on Assets

Gross Margin 

Operating Margin

Net-Profit Margin

Current Ratio

Debt to Assets Ratio

Net-Profit Growth

Return on Assets-Growth

Total Assets-Growth

Revenues-Growth

Gross Margin-Growth

After calculating the ratios for Communication Companies available in the database of SIMFIN. The companies have been ranked based on their score on each ratio

For Instance, company with the highest current ratio (higher the better) has been given the score 13 while the company with lowest current ratio, the score of 1. However, for the ratios like Debt to Asset (lower the better), company with highest Debt to Asset Ratio has been given score of 1, while companies lower on this ratio got higher score.

Eventually, all the scores (based on ranks) for different ratios have been aggregated and company with the highest score in each year has been selected. 

We eventually used this selection for choosing our Best Value Stocks in executing pair trading strategy.

The process then implemented for all the 55 industries in our database,

Average Sample Period return for each industry can be found in Mean of Each Industry_Prediction.csv file

