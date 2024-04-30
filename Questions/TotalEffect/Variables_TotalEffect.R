function(values){
  
  div(class = 'container',
      h3("Variable types"),
      radioButtons("TypExpTot", "Is your exposure variable :", 
                   choices = c("Continuous", "Binary", "Ordinal", "Nominal", "I have several"), 
                   selected = values$TypExpTot),
      br(),
      textAreaInput(
        inputId = "ExpoTot",
        label = "What is its name ?",
        value = values$ExpoTot,
        width = '100%',
        height = '1000%',
        placeholder = "Social class"
      ),
      
      br(), 
      radioButtons("TypOutcomeTot", "Is your outcome variable :", 
                   choices = c("Continuous", "Binary", "Ordinal", "Nominal", "Survival / Time-to-event", "I have several"),
                   selected = values$TypOutcomeTot),
      br(),
      textAreaInput(
        inputId = "OutTot",
        label = "What is its name ?",
        value = values$OutTot,
        width = '100%',
        height = '1000%',
        placeholder = "Mortality"
      ),
      br(),
      actionButton("Var_Tot_Prev", "< Back"),
      actionButton("Var_Tot_Next", "Next >"),
      br()
  )
  
}