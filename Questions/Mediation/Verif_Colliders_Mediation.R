function(values){ 
  div(class = 'container',
      h3("Colliders"),
      htmlOutput("QCollidExpOutMediation"),
      img(src="Collider_exp_out.png", width="35%"),
      radioButtons("CollidExpOutMediation","",
                   choices = c("Yes", "No"),
                   selected = values$CollidExpOutMediation),
      
      br(),
      htmlOutput("QCollidMedOut"),
      img(src="Collider_Mediateur_Outcome.png", width="35%"),
      radioButtons("CollidMedOut","",
                   choices = c("Yes", "No"),
                   selected = values$CollidMedOut),
      
      actionButton("Verif_Collid_Med_Prev", "< Back"),
      actionButton("Verif_Collid_Med_Next", "Next >"),
      br()
  )
}