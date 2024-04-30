function(values){
fluidRow(
  h3("Please check that the information provided is correct"),
  column(12,
         wellPanel(
           h4("Objective"),
           textOutput("ObjectifResumeTot")
         )),
  
  column(12,
         wellPanel(
           h4("Variables"),
           tableOutput("VariableTypeTot")
         )),
  
  column(12,
         wellPanel(
           h4("Constraints"),
           tableOutput("ContraintesTot")
         )),
  
  actionButton("Resume_Tot_Prev", "< Back"),
  actionButton("Valider_Tot", "Confirm")
)
}

