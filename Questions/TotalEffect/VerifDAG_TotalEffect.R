function(values){ 
  div(class = 'container',
      h3("Mediators and colliders"),
    htmlOutput("QMedExpOut"),
    img(src="Mediateur.png", width="35%"),
    radioButtons("MedExpOutTot","",
                 choices = c("Yes", "No"),
                 selected = values$MedExpOutTot),
    
    br(),
    htmlOutput("QCollidExpOut"),
    img(src="Collider.png", width="30%"),
    radioButtons("CollidExpOutTot","",
                 choices = c("Yes", "No"),
                 selected = values$CollidExpOutTot),
      
      actionButton("Verif_Tot_Prev", "< Back"),
      actionButton("Verif_Tot_Next", "Next >"),
      br()
  )
}
  
