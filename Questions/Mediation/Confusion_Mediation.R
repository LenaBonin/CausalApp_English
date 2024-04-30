function(values){div(class = 'container',
                     h3("Confounders"),
                     htmlOutput("QconfusionExpOutMed"),
                     img(src="Confusion_Exp_Out.png", width="30%"),
                     radioButtons("ConfuExpOutMed","Do they all appear on your DAG ? (if there are no confounders for this relationship, check yes)",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuExpOutMed),
                     
                     br(),
                     
                     htmlOutput("QconfusionExpMedMed"),
                     img(src="Confusion_Exp_Med.png", width="30%"),
                     radioButtons("ConfuExpMedMed","Do they all appear on your DAG ? (if there are no confounders for this relationship, check yes)",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuExpMedMed),
                     
                     br(),
                     
                     htmlOutput("QconfusionMedOutMed"),
                     img(src="Confusion_Med_Out.png", width="30%"),
                     radioButtons("ConfuMedOutMed","Do they all appear on your DAG ? (if there are no confounders for this relationship, check yes)",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuMedOutMed),
                     
                     br(),
                     
                     radioButtons("ConfuNonMesureMed","Are some confounders not measured in your data ?",
                                  choices = c("Yes", "No"),
                                  selected = values$ConfuNonMesureMed),
                     
                     br(),
                     htmlOutput("ConfuInfluence"),
                     img(src="Confusion_Intermediaire.png", width="30%"),
                     radioButtons("ConfuInfluence","",
                                  choices = c("Yes", "No"),
                                  selected = ifelse(is.null(values$ConfuInfluence), "No", values$ConfuInfluence)),
                     
                     conditionalPanel(
                       condition = "input.ConfuInfluence == 'Yes'",
                       div(
                         class = "additional-question",
                         radioButtons("ShortTime", "Is the time between being exposed and the measure of the intermediate variable very short ?",
                                    choices = c("Yes", "No"),
                                    selected = values$ShortTime)
                       )
                     ),
                     
                     conditionalPanel(
                       condition = "input.ShortTime == 'No' & input.ConfuInfluence == 'Yes'",
                       div(
                         class = "additional-question-2",
                         radioButtons("add_hyp_cond", "Do you find the following hypothesis credible?  \n
                                      Conditional on (i.e. after adjustment for) exposure, mediator (intermediate variable of interest) and intermediate confounders, there is no unmeasured confounder of the mediator-outcome relationship.",
                                      choices = c("Yes", "No"),
                                      selected = values$add_hyp_cond)
                       )
                     ),
                     
                     
                     br(),
                     actionButton("Confu_Med_Prev", "< Back"),
                     actionButton("Confu_Med_Next", "Next >"),
                     br()
)
}