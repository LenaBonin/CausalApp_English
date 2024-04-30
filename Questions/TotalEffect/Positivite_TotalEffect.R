# Question pour voir s'il y a un risque évident que l'hypothèse de positivité ne soit pas vérifiée

function(values){ 
  div(class = 'container',
      h3("Positivity"),
      radioButtons("QPosiTot","Do you suspect that certain combinations of confounders correspond only to exposed/unexposed individuals (or to specific values of the exposure),
                   i.e are there individuals who cannot be exposed/unexposed because of their characteristics ?",
                   choices = c("Yes", "No", "I don't know"),
                   selected = values$QPosiTot),
      
      br(),
      
      actionButton("Posi_Tot_Prev", "< Back"),
      actionButton("Posi_Tot_Next", "Next >"),
      br()
  )
}