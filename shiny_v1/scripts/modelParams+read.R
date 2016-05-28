#For model+params.xlsx


model.def <- read_excel("data/model+params+v2.xlsx", sheet = 1)

# Reading in data 
model.init <- read_excel("data/model+params+v2.xlsx", sheet = 2)
model.params <- read_excel("data/model+params+v2.xlsx", sheet = 3)
model.inter <- read_excel("data/model+params+v2.xlsx", sheet = 4)

# Subsetting to columns that are needed
model.init <- model.init[,2:length(names(model.init))]
model.params <- model.params[,2:length(names(model.params))]
model.inter <- model.inter[,2:length(names(model.inter))]

# Getting rid of last NA column
model.init <- model.init[1:3,]
model.params <- model.params[1:8,]
model.inter <- model.inter[1:2,]








