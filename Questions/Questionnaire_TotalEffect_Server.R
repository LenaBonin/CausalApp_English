### Ce fichier contient les élément de la fonction serveur qui concernent les questions pour estimer un effet total ###

observe_events_TotalEffect <- function (input, output, session, currentPage, values, SelectionTotal){
# # Bouton Prev après les Q sur le message que lon rentre dans les effets totaux
# observeEvent(input$Mtot_Prev, {
#   currentPage(Q1)
# })
# 
# # Bouton Next après les Q sur le message que lon rentre dans les effets totaux
# observeEvent(input$Mtot_Next, {
#   currentPage(VarTot)
# })

# Bouton Prev après les Q sur les variables
observeEvent(input$Var_Tot_Prev, {
  currentPage(Q1)
})

# Bouton Next après les Q sur les variables
observeEvent(input$Var_Tot_Next, {
  if(input$TypExpTot == "I have several" & input$TypOutcomeTot == "I have several"){
    shinyalert("Multiple exposures and outcomes", "You can only have one exposure and one outcome. Consider doing separate analyses for each exposure/outcome combination")
  }
  else if(input$TypExpTot == "I have several") shinyalert("Multiple exposures", "You can only have one exposure. Consider doing a separate analysis per exposure. Or, if the exposures are sequential, then you are in the case of an intermediate variable. In this case, go back to the choice of objective and modify your answer")
  else if (input$TypOutcomeTot == "I have several") shinyalert("Multiple outcomes", "You can only have one outcome. Consider doing a separate analysis per outcome")
  else {
    values$TypExpTot <- input$TypExpTot
    values$TypOutcomeTot <- input$TypOutcomeTot
    values$ExpoTot <- input$ExpoTot
    values$OutTot <- input$OutTot
    currentPage(ConfusionTot)
  } 
})

# Texte pour faire penser aux facteurs de confusion
output$QconfusionExpOut <- renderText({
  paste("<b> Think carefully about all the potential confounders between", ifelse(input$ExpoTot=="", "the exposure", input$ExpoTot), "and", ifelse(input$OutTot=="", "the outcome", input$OutTot),"</b>,
        i.e. all the variables that affect both", ifelse(input$ExpoTot=="", "exposure", input$ExpoTot), "and", ifelse(input$OutTot=="", "outcome", input$OutTot),"<br> <br>")}) 


# Bouton Prev après Q sur les facteurs de confusion
observeEvent(input$Confu_Tot_Prev, {
  currentPage(VarTot)
})

# Bouton Next après Q sur les facteurs de confusion
observeEvent(input$Confu_Tot_Next, {
  if(input$ConfuTot == "No") shinyalert("Missing confounders", "You must add all confounders to your DAG before going on")
  else {
    values$ConfuTot <- input$ConfuTot
    values$ConfuNonMesureTot <- input$ConfuNonMesureTot
    currentPage(VerifDagTot)
  }
})


# Texte pour faire penser aux médiateurs
output$QMedExpOut <- renderText({
  paste("<b> Does your graph contain variables that are affected by", ifelse(input$ExpoTot=="", "the exposure", input$ExpoTot), "and which in turn affect", ifelse(input$OutTot=="", "the outcome", input$OutTot),"</b>,
        i.e. does it contain mediators between your exposure and your outcome variables ?")}) 

# Texte pour faire penser aux colliders
output$QCollidExpOut <- renderText({
  paste("<b> Does your graph contain variables that are affected by both", ifelse(input$ExpoTot=="", "exposure", input$ExpoTot), "and", ifelse(input$OutTot=="", "outcome", input$OutTot),"</b>,
        i.e. does it contain colliders between your exposure and your outcome variables ?")})


# Bouton Prev après Q sur les médiateurs et colliders
observeEvent(input$Verif_Tot_Prev, {
  currentPage(ConfusionTot)
})

# Bouton Next après Q sur les médiateurs et colliders
observeEvent(input$Verif_Tot_Next, {
  if (input$MedExpOutTot=="Yes" & input$CollidExpOutTot=="Yes") shinyalert("Remove mediators and colliders", HTML("To estimate a total effect of an exposure on an outcome it is unnecessary to include mediators on your DAG\n  You must not include either mediators nor colliders in your analysis as they would result in biased results. 
                                                                                                                  We advise you to remove them from your DAG to be sure not to include them in your analysis. \n \n To continue, check 'No'"))
  else if(input$MedExpOutTot=="Yes") shinyalert("Remove mediators", HTML("To estimate a total effect of an exposure on an outcome it is unnecessary to include mediators on your DAG. You must not include them in your analysis as they would lead to biased result. We advise you to remove them from your DAG to be sure not to include them in your analysis. \n \n To continue, check 'No'"))
  else if (input$CollidExpOutTot=="Yes") shinyalert("Remove colliders", HTML("Colliders can appear on a DAG, BUT you MUST NOT include them in your analysis as they would bias the results. 
                                                                             We advise you to remove them from your DAG to be sure not to include them in your analysis. \n \n To continue, check 'No'"))
  else{
    values$MedExpOutTot <- input$MedExpOutTot
    values$CollidExpOutTot <- input$CollidExpOutTot
    currentPage(RepeteTot)
  }
})

# Bouton Prev après Q sur les variables répétées
observeEvent(input$Repet_Tot_Prev, {
  currentPage(VerifDagTot)
})

# Bouton Next après Q sur les variables répétées
observeEvent(input$Repet_Tot_Next, {
  values$ExpRepTot <- input$ExpRepTot
  values$ConfRepTot <- input$ConfRepTot
  values$OutRepTot <- input$OutRepTot
  currentPage(PosiTot)
})

# Bouton Prev après question sur la positivité
observeEvent(input$Posi_Tot_Prev, {
  currentPage(RepeteTot)
})

# Bouton Next après question sur la positivité
observeEvent(input$Posi_Tot_Next, {
  values$QPosiTot <- input$QPosiTot
  currentPage(ResumeTot)
})


# Tableau résumé du type des variables exposition et outcome
output$VariableTypeTot <- renderTable({
    df <- data.frame("Variable" = c("Exposure", "Outcome"),
               "Type" = c(values$TypExpTot, values$TypOutcomeTot))
    SelectionTotal$VarType <- df
    df
})

output$ObjectifResumeTot <- renderText({
  obj <- paste("To study the effect of", ifelse(input$ExpoTot=="", "an exposure", input$ExpoTot), "on", ifelse(input$OutTot=="", "an outcome", input$OutTot))
  SelectionTotal$Obj <- obj
  obj
})

output$ContraintesTot <- renderTable({
  ExpRepet <- ifelse(input$ExpRepTot=="Yes", "Repeated", "Not repeated")
  OutRepet <- ifelse(input$OutRepTot=="Yes", "Repeated", "Not repeated")
  if(input$ExpRepTot=="Yes"){
    ConfRepet <- ifelse(input$ConfRepTot=="Yes", "Repeated", "Not repeated")
    df <- data.frame("Criterion" = c("Exposure", "Confounder(s)", "Outcome", "Unmeasured confounders", "Positivity violation"),
               "Response" = c(ExpRepet, ConfRepet, OutRepet, input$ConfuNonMesureTot, input$QPosiTot))
  }
  else{
    df <- data.frame("Criterion" = c("Exposure", "Outcome", "Unmeasured confounders", "Positivity violation"),
              "Response" = c(ExpRepet, OutRepet, input$ConfuNonMesureTot, input$QPosiTot))
  }
  SelectionTotal$Constraint <- df
  df
})

# Bouton Prev après le résumé
observeEvent(input$Resume_Tot_Prev, {
  currentPage(PosiTot)
})

#Bouton Valider après résumé des réponses
observeEvent(input$Valider_Tot, {
  currentPage(RecoTot)
})

}