function(values){
  div(class = 'container',
      h3("and/or of the type :"),
      
      br(),
      htmlOutput("QMedB1"),
      radioButtons("ObjMedB1", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedB1),
      br(),
      htmlOutput("QMedB2"),
      radioButtons("ObjMedB2", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedB2),
      
      br(),
      htmlOutput("QMedB3"),
      radioButtons("ObjMedB3", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedB3),
      
      br(),
      htmlOutput("QMedB4"),
      radioButtons("ObjMedB4", "",
                   choices = c("Yes", "No"),
                   selected = values$ObjMedB4),
      
      
      actionButton("MedB_Prev", "< Back"),
      actionButton("MedB_Next", "Next >")
      
  )
}