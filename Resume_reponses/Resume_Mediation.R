function(values){
  fluidRow(
    h3("Please check that the information provided is correct"),
    column(12,
           wellPanel(
             h4("Objective(s)"),
             htmlOutput("ObjectifResumeMed")
           )),
    
    column(12,
           wellPanel(
             h4("Variables"),
             tableOutput("VariableTypeMed")
           )),
    
    column(12,
           wellPanel(
             h4("Constraints"),
             h5("Variables"),
             tableOutput("ContraintesMed"),
             br(),
             h5("Confounders"),
             tableOutput("ContraintesMed2"),
             h5("Positivity"),
             tableOutput("ContraintesMed3")
           )),
    
    column(12,
           wellPanel(
             h4("Interaction between exposure and mediator"),
             tableOutput("InteractionMed")
           )),
    
    actionButton("Resume_Med_Prev", "< Back"),
    actionButton("Valider_Med", "Confirm")
  )
}