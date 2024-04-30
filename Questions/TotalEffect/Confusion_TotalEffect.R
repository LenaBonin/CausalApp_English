function(values){
  div(class = 'container',
      h3("Confounders"),
      htmlOutput("QconfusionExpOut"),
      img(src="Confusion.png", width="30%"),
      radioButtons("ConfuTot","Do they all appear on your DAG ?",
                  choices = c("Yes", "No"),
                  selected = values$ConfuTot),

      br(),
      radioButtons("ConfuNonMesureTot","Are any of these confounders not measured in your data ?",
                  choices = c("Yes", "No"),
                  selected = values$ConfuNonMesureTot),
    
      br(),
      actionButton("Confu_Tot_Prev", "< Back"),
      actionButton("Confu_Tot_Next", "Next >"),
      br()
  )
}