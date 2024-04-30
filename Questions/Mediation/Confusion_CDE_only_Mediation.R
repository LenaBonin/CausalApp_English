function(values){div(class = 'container',
                     h3("Confounders"),
                     htmlOutput("QconfusionExpOutMed"),
                     img(src="Confusion_Exp_Out.png", width="30%"),
                     radioButtons("ConfuExpOutMed","Do they all appear on your DAG ? (if there are no confounders for this relationship, check yes)",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuExpOutMed),
                     
                     br(),
                     
                     
                     htmlOutput("QconfusionMedOutMed"),
                     img(src="Confusion_Med_Out.png", width="30%"),
                     radioButtons("ConfuMedOutMed","Do they all appear on your DAG ? (if there are no confounders for this relationship, check yes)",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuMedOutMed),
                     
                     br(),
                     
                     radioButtons("ConfuNonMesureMed","Are some of them not measured in your data ?",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuNonMesureMed),
                     
                     
                     
                     br(),
                     actionButton("Confu_Med_Prev", "< Back"),
                     actionButton("Confu_Med_CDE_Next", "Next >"),
                     br()
)
}