function(values){ 
  div(class = 'container',
      h3("Intermediate confounding and repeated measurements"),
      radioButtons("ExpRepMed",paste("Is the measurement of your exposure", values$Expo,  "repeated over time in your data ?"),
                   choices = c("Yes", "No"), 
                   selected = values$ExpRepMed),
      
      br(),
      radioButtons("MediateurRepMed",paste("Is the measurement of your intermediate variable of interest", values$Mediateur, "repeated over time in your data ?"),
                   choices = c("Yes", "No"),
                   selected = values$MediateurRepMed),
      
      br(),
      radioButtons("OutRepMed",paste("Is the measurement of your outcome", values$Outcome, "repeated over time in your data ?"),
                                           choices = c("Yes", "No"),
                                           selected = values$OutRepMed),
                   
      actionButton("Repet_Med_Prev", "< Back"),
      actionButton("Repet_Med_Next", "Next >"),
      br()
  )
}