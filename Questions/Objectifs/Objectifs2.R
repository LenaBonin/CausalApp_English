function(values){
  div(class = 'container',
      p("In the previous example ('to study the role of tobacco as an intermediary in the relationship between social class and mortality'), we suggest that you replace the variables with your own."),
      p("If you do not enter anything, the terms 'exposure', 'intermediate variable' and 'outcome' will be used for the next questions"),
      textAreaInput(
        inputId = "Expo",
        label = "What variable would you like to replace 'social class' with, i.e. what is your exposure variable ?",
        value = values$Expo,
        width = '100%',
        height = '1000%',
        placeholder = "Social class"
      ),
      
      textAreaInput(
        inputId = "Mediateur",
        label = "What variable would you like to replace 'tobacco' with, i.e. what is your intermediate variable ?",
        value = values$Mediateur,
        width = '100%',
        height = '1000%',
        placeholder = "Tobacco"
      ),
      
      textAreaInput(
        inputId = "Outcome",
        label = "What variable would you like to replace 'mortality' with, i.e. what is your variable of interest/outcome ?",
        value = values$Outcome,
        width = '100%',
        height = '1000%',
        placeholder = "Mortality"
      ),
      br(),
      actionButton("EndObj2Prev", "< Back"),
      actionButton("EndObj2Next", "Next >"),
      br()
  )
      
}