function(values){
  div(class = 'container',
      h3("More specifically, is your objective along the lines of :"),
      # br(),
      # htmlOutput("QMedA0"),
      # radioButtons("ObjMedA0", "",
      #              choices = c("Oui", "Non"),
      #              selected = values$ObjMedA0),
      br(),
      htmlOutput("QMedA1"),
      radioButtons("ObjMedA1", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedA1),
      br(),
      htmlOutput("QMedA2"),
      radioButtons("ObjMedA2", "",
      choices = c("Yes", "No"),
      selected = values$ObjMedA2),
      
      br(),
      htmlOutput("QMedA3"),
      radioButtons("ObjMedA3", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedA3),
      
      
      actionButton("MedA_Prev", "< Back"),
      actionButton("MedA_Next", "Next >")
      
  )
}