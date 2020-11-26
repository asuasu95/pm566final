

#Read file
covid = fread("data/Provisional_COVID-19_Death_Counts_by_Sex__Age__and_State.csv")

#Calculate proportionate mortality ratio due to COVID-19
covid$PMR=round(covid$`COVID-19 Deaths`/covid$`Total Deaths` ,4)



covid_2=covid[which(covid$Sex != "All Sexes" & covid$State != "United States" & covid$`Age group`!="All Ages"),]
covid_2=covid_2[which(covid_2$`Age group` == "Under 1 year" | covid_2$`Age group` == "1-4 years" | covid_2$`Age group` == "5-14 years" | covid_2$`Age group` == "15-24 years" | covid_2$`Age group` == "25-34 years" | covid_2$`Age group` == "35-44 years" | covid_2$`Age group` == "45-54 years" | covid_2$`Age group` == "55-64 years" | covid_2$`Age group` == "65-74 years" | covid_2$`Age group` == "75-84 years" | covid_2$`Age group` == "85 years and over")]
covid_2 = drop_na(covid_2,`COVID-19 Deaths`)
covid_2$`Age group`[which(covid_2$`Age group`=="Under 1 year")]="00-01 years"
covid_2$`Age group`[which(covid_2$`Age group`=="1-4 years")]="01-04 years"
covid_2$`Age group`[which(covid_2$`Age group`=="5-14 years")]="05-14 years"
covid_2=covid_2[which(covid_2$Sex != "Unknown")]

covid_3=covid[which(covid$Sex != "All Sexes" & covid$State != "United States" & covid$`Age group`=="All Ages"),]
covid_3=subset(covid_3,select = c("State","Sex","COVID-19 Deaths"))
covid_3=covid_3[which(covid_3$Sex != "Unknown")]
covid_3[65,3]=covid_3[65,3]+covid_3[67,3]
covid_3[66,3]=covid_3[66,3]+covid_3[68,3]
covid_3=covid_3[-c(67,68),]

covid_state=covid[which(covid$Sex == "All Sexes" & covid$State != "United States" & covid$`Age group`=="All Ages"),]
covid_state[33,7:12]=covid_state[33,7:12]+covid_state[34,7:12]
covid_state=covid_state[-34, ]
covid_state$PMR=round(covid_state$`COVID-19 Deaths`/covid_state$`Total Deaths`,4)
covid_state=covid_state[-c(9,52),]

state_pop= fread("data/nst-est2019-alldata.csv")
state_pop=state_pop[,c(5,17)]
state_pop=state_pop[-c(1:5,14,57),]




State_area=data.frame(state.name,state.area)
colnames(state_pop)[1]="state.name"
state_pop=merge(state_pop,State_area,by="state.name")
state_pop$pop_density=state_pop$POPESTIMATE2019/state_pop$state.area

colnames(state_pop)[1]="State"
covid_state=merge(covid_state,state_pop,by = "State")
covid_simp=subset(covid_state, select = c("State","COVID-19 Deaths","Total Deaths","PMR","POPESTIMATE2019","pop_density"))
covid_simp= covid_simp[order(-covid_simp$`COVID-19 Deaths`),]
colnames(covid_simp)[5:6]=c("Population","Population_Density")





covid_case=fread("data/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")
table(covid_case$state)

covid_case=covid_case[which(covid_case$submission_date=="10/17/2020")]
covid_case=subset(covid_case,select = c("state","tot_cases","tot_death"))
covid_case[39,2:3]=covid_case[39,2:3]+covid_case[18,2:3]
covid_case=covid_case[-18, ]

stateinfo=data.frame(state.name,state.abb)
colnames(stateinfo)[2]="state"

covid_case=merge(covid_case,stateinfo,by="state")
covid_case=subset(covid_case,select = c("state.name","tot_cases","tot_death"))
covid_case$cfr=round(covid_case$tot_death/covid_case$tot_cases,3)


