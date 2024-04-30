function(values){ 
  div(class = 'container',
      h3("Exposure-Mediator interaction"),
      htmlOutput("QInteractionExpMed"),
      radioButtons("InteractionExpMed","",
                   choices = c("Yes", "No"),
                   selected = values$InteractionExpMed),
      
      br(),
      conditionalPanel(
        condition = "input.InteractionExpMed == 'No'",
        div(
          class = "additional-question",
          radioButtons("InteractionDirIndir", "If there is actually an interaction, in which effect would you like it to be taken into account ?",
                       choiceNames = c("Direct effect (that does not go through the mediator (intermediate variable of interest))",
                                       "Indirect effect (that goes through the mediator)"),
                       choiceValues = c("Direct", "Indirect"),
                       selected = values$InteractionDirIndir)
        )
      ),
      
      
      actionButton("Interaction_Med_Prev", "< Back"),
      actionButton("Interaction_Med_Next", "Next >"),
      br()
  )
}