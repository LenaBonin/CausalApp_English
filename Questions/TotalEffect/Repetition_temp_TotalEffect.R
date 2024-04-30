function(values){ 
  div(class = 'container',
      h3("Intermediate confounders and repeated measurements"),
      radioButtons("ExpRepTot","Is your exposure measurement repeated over time ?",
                  choices = c("Yes", "No"), 
                  selected = values$ExpRepTot),
    
      br(),
      
      conditionalPanel(
        condition = "input.ExpRepTot == 'Oui'",
        div(
          class = "additional-question",
          radioButtons("ConfRepTot","Is the measurement of at least one confounder repeated over time ?",
                       choices = c("Yes", "No"),
                       selected = values$ConfRepTot)
        )
      ),
    
      br(),
      radioButtons("OutRepTot","Is your outcome measurement repeated over time ?",
                  choices = c("Yes", "No"),
                  selected = values$OutRepTot),
    
      actionButton("Repet_Tot_Prev", "< Back"),
      actionButton("Repet_Tot_Next", "Next >"),
      br()
    )
}
