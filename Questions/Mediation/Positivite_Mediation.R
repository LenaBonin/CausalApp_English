# Questions pour voir s'il y a un risque évident que l'hypothèse de positivité ne soit pas vérifiée

function(values){ 
  div(class = 'container',
      h3("Positivity"),
      htmlOutput("QPosiExpMed"),
      radioButtons("PosiExpMed","",
                   choices = c("Yes", "No", "I don't know"),
                   selected = values$PosiExpMed),
      
      br(),
      
      htmlOutput("QPosiMedMed"),
      radioButtons("PosiMedMed","",
                   choices = c("Yes", "No", "I don't know"),
                   selected = values$PosiMedMed),
                   
                   br(),
                   
                   actionButton("Posi_Med_Prev", "< Back"),
                   actionButton("Posi_Med_Next", "Next >"),
                   br()
      )
}