function(values){
  
  div(class = 'container',
      h3("variable types"),
      radioButtons("TypExpMed", HTML(paste("Is your exposure variable <i>", values$Expo, "</i>: ")), 
                   choices = c("Continuous", "Binary", "Ordinal", "Nominal", "I have several"), 
                   selected = values$TypExpMed),
      
      
      br(), 
      radioButtons("TypOutcomeMed", HTML(paste("Is your outcome variable <i>", values$Outcome, "</i>:")), 
                   choices = c("Continuous", "Binary", "Ordinal", "Nominal", "Survival / Time-to-event", "I have several"),
                   selected = values$TypOutcomeMed),
      
      br(),
      conditionalPanel(
        condition = "input.TypOutcomeMed == 'Binary' | input.TypOutcomeMed=='Survival / Time-to-event'",
        div(
          class = "additional-question",
          radioButtons("RareOutcome","Is your outcome rare (approx. less than 10%) ?",
                       choices = c("Yes", "No"),
                       selected = values$RareOutcome)
        )
      ),
      
      br(),
      radioButtons("EffetTotVerif", "Have you ever tested the total effect of your exposure on the outcome?", 
                   choiceNames = c("Yes, with my data, I found one", 
                               "Yes, with my data, there isn't any (or it isn't significant), but I still would like to do a mediation analysis.",
                               "No, but it has been done in the literature", 
                               "No"),
                   choiceValues = c("Yes_ok", "Yes_pb", "No_litt", "No"),
                   selected = values$EffetTotVerif),
      
      
      br(),
      radioButtons("TypMediateurMed", HTML(paste("Is your intermediate variable between exposure and outcome <i>", values$Mediateur, "</i> ? (this variable will also be called 'mediator' in the next questions)")), 
                   choices = c("Continuous", "Binary", "Ordinal", "Nominal", "I have several"), 
                   selected = values$TypMediateurMed),

      br(),
      actionButton("Var_Med_Prev", "< Back"),
      actionButton("Var_Med_Next", "Next >"),
      br()
  )
  
}