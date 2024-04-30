observe_events_Mediation <- function(input, output, session, currentPage, values, SelectionMediation){
  
  # Button Prev variable type mediation
  observeEvent(input$Var_Med_Prev, {
    currentPage(MedB)
  })
  
  # Button Next variable type mediation
  observeEvent(input$Var_Med_Next, {
    if(input$TypExpMed == "I have several" & input$TypOutcomeMed == "I have several"){
      shinyalert("Multiple exposures and outcomes", "You can only have one exposure and one outcome variable. Consider doing separate analyses for each exposure/outcome combination")
    }
    else if(input$TypExpMed == "I have several") shinyalert("Multiple exposures", "You can only have one exposure.  Consider doing a saparate analysis per exposure. If exposures are sequential, then you might consider the first one as your exposure and the next as intermediate variables (mediators).")
    else if (input$TypOutcomeMed == "I have several") shinyalert("Multiple outcomes", "You can only have one outcome. Consider doing a separate analysis per outcome")
    else if (input$EffetTotVerif=="No"){
      showModal(modalDialog(
        title = HTML("Before starting a mediation analysis, it is recommended to check that there is indeed an effect of the exposure on the outcome. If there is not, the analysis of the role of the intermediate variable is in most cases of no interest. There are, however, rare cases where there is no total effect of an exposure on an outcome, but where there is a mediated effect. This happens if the effect that passes through the intermediate variable and the effect that does not pass through this variable cancel each other out. Bear in mind, however, that this is a rather rare case.
        <br> <br>  Do you first want to check the total effect of the exposure on the outcome (i.e. by first omitting your intermediate variable) or continue directly to study the role of your intermediate variable on your exposure-outcome relationship (mediation analysis) ?"),
        footer = tagList(actionButton("Back_eff_tot", "Test total effect"),
                         actionButton("Confirm_mediation", "Continue with a mediation analysis"),
                         modalButton("Cancel"))
      )
      )
    } 
    
    else if (input$EffetTotVerif=="Yes_pb"){
      showModal(modalDialog(
        title = HTML("In most cases, if there is no effect of the exposure on the outcome, running a mediation analysis using an intermediate variable is of no interest. There are, however, rare cases where there is no total effect of the exposure on the outcome, but where there is a mediated effect. This happens if the effect passing through the intermediate variable of interest and the effect not passing through it cancel each other out. Bear in mind, however, that this case is rather rare.
        <br> <br> Would you still like to study the role of the intermediate variable between your exposure and your outcome (mediation analysis) ?"),
        footer = tagList(actionButton("Confirm_mediation", "Continue with a mediation analysis"),
                         modalButton("Cancel"))
      )
      )
    }
    #shinyalert("Effet total non vérifié", "Avant de commencer une analyse de médiation, vérifier dans un premier temps qu'il y a bien un effet total.
    #                                                \n Retournez en arrière à la question de la définition de votre objectif et sélectionnez uniquement l'effet de la classe sociale sur la mortalité.")
    else if (input$TypMediateurMed == "I have several") shinyalert("Multiple mediators", "For now, this application cannot handle the case of multiple mediators.") # A enlever quand on pourra le gérer
    else {
      values$TypExpMed <- input$TypExpMed
      values$TypMediateurMed <- input$TypMediateurMed
      EffetTotVerif <- input$EffetTotVerif
      values$TypOutcomeMed <- input$TypOutcomeMed
      currentPage(RepeteMed)
    } 
  })
  
  # Si la personne persiste à vouloir faire une analyse de médiation même sans effet total
  observeEvent(input$Confirm_mediation,{
    values$TypExpMed <- input$TypExpMed
    values$TypMediateurMed <- input$TypMediateurMed
    values$EffetTotVerif <- input$EffetTotVerif
    values$TypOutcomeMed <- input$TypOutcomeMed
    removeModal()
    currentPage(RepeteMed)
  })
  
  # Si la personne se dirige finalement sur un effet total
  observeEvent(input$Back_eff_tot,{
    values$TypExpMed <- input$TypExpMed
    values$TypMediateurMed <- input$TypMediateurMed
    values$EffetTotVerif <- input$EffetTotVerif
    values$TypOutcomeMed <- input$TypOutcomeMed
    values$question2 <- "No"
    removeModal()
    currentPage(Q1)
  })
  
  #Button Prev après questions sur la répétition
  observeEvent(input$Repet_Med_Prev, {
    currentPage(TypVarMed)
  })
  
  #Button Next après questions sur la répétition
  observeEvent(input$Repet_Med_Next, {
    values$ExpRepMed <- input$ExpRepMed
    values$MediateurRepMed <- input$MediateurRepMed
    values$OutRepMed <- input$OutRepMed
    
    if((input$ObjMedA1=="Yes" || input$ObjMedA2=="Yes" || input$ObjMedA3=="Yes") 
       & (input$ObjMedB1=="No" & input$ObjMedB2=="No" & input$ObjMedB3=="No" & input$ObjMedB4=="No")){
      currentPage(ConfuMed_CDE) # Estimand is only CDE => less hypothesis are necessary => less questions
    }
    else currentPage(ConfuMed)
  })
  
  #Button Prev après questions sur la confusion
  observeEvent(input$Confu_Med_Prev, {
    currentPage(RepeteMed)
  })
  
  
  # observeEvent(input$question1_response, {
  #   values$ConfuInfluence<- input$ConfuInfluence
  #   
  #   # Vérifier si la réponse est "Oui"
  #   if (input$ConfuInfluence == "Oui") {
  #     # Afficher la question supplémentaire en utilisant renderUI
  #     output$QcondTemporalite <- renderUI({
  #       # Code HTML pour la question supplémentaire
  #       p(paste("Le temps entre l'observation de l'exposition et celle du médiateur est-il très court?"))
  #       radioButtons("additional_question_response", "",
  #                    choices = c("Oui", "Non"))
  #     })
  #   } else {
  #     # Masquer la question supplémentaire si la réponse n'est pas "Oui"
  #     output$QcondTemporalite <- renderUI(NULL)
  #   }
  # })
  
  #Button Next après questions sur la confusion
  observeEvent(input$Confu_Med_Next, {
    if(input$ConfuExpOutMed=="No" | input$ConfuExpMedMed=="No" | input$ConfuMedOutMed=="No"){
      shinyalert("Missing confounders", "All confounders for the three relationships
                 exposure/outcome, exposure/mediator, mediator/outcome must appear on your DAG. \n
                 Add them before continuing.")
    }
    else{
      values$ConfuExpOutMed = input$ConfuExpOutMed
      values$ConfuExpMedMed = input$ConfuExpMedMed
      values$ConfuMedOutMed = input$ConfuMedOutMed
      values$ConfuNonMesureMed= input$ConfuNonMesureMed
      values$ConfuInfluence = input$ConfuInfluence
      values$ShortTime = input$ShortTime
      values$add_hyp_cond = input$add_hyp_cond
      currentPage(CollidMed)
    }
  })
  
  #Button Next après questions sur la confusion dans le cas d'uniquement CDE
  observeEvent(input$Confu_Med_CDE_Next, {
    if(input$ConfuExpOutMed=="No" | input$ConfuMedOutMed=="No"){
      shinyalert("Missing confounders", "All confounders of the exposure-outcome and the mediator-outcome relationships must appear on your DAG \n
                 Add them before continuing")
    }
    else{
      values$ConfuExpOutMed = input$ConfuExpOutMed
      values$ConfuMedOutMed = input$ConfuMedOutMed
      values$ConfuNonMesureMed= input$ConfuNonMesureMed
      currentPage(CollidMed)
    }
  })
  
  #Button Prev après questions sur les colliders
  observeEvent(input$Verif_Collid_Med_Prev, {
    if((input$ObjMedA1=="Yes" || input$ObjMedA2=="Yes" || input$ObjMedA3=="Yes") 
       & (input$ObjMedB1=="No" & input$ObjMedB2=="No" & input$ObjMedB3=="No" & input$ObjMedB4=="No")){
      currentPage(ConfuMed_CDE)
    }
    else currentPage(ConfuMed)
  })
  
  #Button Next après questions sur les colliders
  observeEvent(input$Verif_Collid_Med_Next, {
    if(input$CollidExpOutMediation=="Yes" | input$CollidMedOut=="Yes"){
      shinyalert("Remove colliders", "Colliders can appear on a DAG, BUT you MUST NOT include them in your analysis as they would bias the results.
      We advise you to remove them from your DAG to be sure not to include them in your analysis. \n 
                 \n To continue, check 'No'")
    }
    else{
      values$CollidExpOutMediation = input$CollidExpOutMediation
      values$CollidMedOut = input$CollidMedOut
      currentPage(PositiviteMed)
    }
  })
  
  # Button Prev après questions sur la positivité
  observeEvent(input$Posi_Med_Prev, {
    currentPage(CollidMed)
  })
  
  #Button Next après questions sur la positivité
  observeEvent(input$Posi_Med_Next, {
    values$PosiExpMed <- input$PosiExpMed
    values$PosiMedMed <- input$PosiMedMed
    currentPage(InteractionMed)
  })
  
  #Button Prev après questions sur l'interaction
  observeEvent(input$Interaction_Med_Prev, {
    currentPage(PositiviteMed)
  })
  
  #Button Next après questions sur l'interaction
  observeEvent(input$Interaction_Med_Next, {
    values$InteractionExpMed <- input$InteractionExpMed
    values$InteractionDirIndir <- input$InteractionDirIndir
    currentPage(ResumeMed)
  })
  
  #Button Prev après résumé des réponses
  observeEvent(input$Resume_Med_Prev, {
    currentPage(InteractionMed)
  })
  
  #Button Valider après résumé des réponses
  observeEvent(input$Valider_Med, {
    currentPage(RecoMed)
  })
  
  ### Texte questions confusion ###

  output$QconfusionExpOutMed <- renderText({
    paste("<b> Think carefully about all the potential confounders between the exposure <i>", ifelse(input$Expo=="", "", input$Expo), "</i> and the outcome <i>", ifelse(input$Outcome=="", "", input$Outcome),"</i> </b>,
        i.e. all variables that affect both", ifelse(input$Expo=="", "exposure", input$Expo), "and", ifelse(input$Outcome=="", "the outcome", input$Outcome),"<br>")}) 
  
  output$QconfusionExpMedMed <- renderText({
    paste("<b> Think carefully about all the potential confounders between the exposure <i>", ifelse(input$Expo=="", "", input$Expo), "</i> and the intermediate variable (mediator) <i>", ifelse(input$Mediateur=="", "", input$Mediateur),"</i> </b>,
        i.e. all variables that affect both", ifelse(input$Expo=="", "the exposure", input$Expo), "and", ifelse(input$Mediateur=="", "the mediator", input$Mediateur),"<br>")}) 
  
  output$QconfusionMedOutMed <- renderText({
    paste("<b> Think carefully about all the potential confounders between the mediator <i>
    ", ifelse(input$Mediateur=="", "", input$Mediateur), "</i> and the outcome <i>", ifelse(input$Outcome=="", "", input$Outcome),"</i> </b>,
        i.e. all variables that affect both", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur), "and", ifelse(input$Outcome=="", "the outcome", input$Outcome),"<br>")}) 
  
  output$ConfuInfluence <- renderText({
    paste("<b> Is at least one of the confounders between the mediator <i>", input$Mediateur, "</i> and the outcome <i>", input$Outcome,
    "</i> affected by the exposure <i>", input$Expo,"</i> </b>,
    i.e. are there intermediate confounders ?")}) 
  
  ### Texte pour faire penser aux colliders ###
  output$QCollidExpOutMediation <- renderText({
    paste("<b> Does your graph contain variables that are affected by both", ifelse(input$Expo=="", "the exposure", input$Expo), "and", ifelse(input$Outcome=="", "the outcome", input$Outcome),"</b>,
        i.e. does it contain colliders between the exposure and the outcome ?")})
  
  output$QCollidMedOut <- renderText({
    paste("<b> Does your graph contain variables that are affected by both", ifelse(input$Mediateur=="", "the intermediate variable (mediator)", input$Mediateur), "and", ifelse(input$Outcome=="", "the outcome", input$Outcome),"</b>,
        i.e.  does it contain colliders between the mediator and the outcome ?")})
  
  ### Texte pour question sur la positivité de l'exposition ###
  output$QPosiExpMed <- renderText({
    "<b> Do you suspect that certain combinations of confounders correspond only to exposed/unexposed individuals (or to specific values of the exposure variable), </b>
          i.e. are there individuals who cannot be exposed/unexposed (are cannot take some values of the exposure variable) because of their characteristics ?"
  })
  
  ### Texte pour question sur la positivité du médiateur ###
  output$QPosiMedMed <- renderText({
    paste("<b> Do you suspect that certain combinations of confounders and exposure lead systematically to the same value(s) of the intermediate variable </b> <br> 
          i.e. are there individuals who cannot take certain values of", ifelse(input$Mediateur=="", "the mediator", input$Mediateur), "because of", ifelse(input$Expo=="", "their exposure value", paste("their value of", input$Expo)) ,"?")
  })
  
  ### Texte pour le terme d'interaction ###
  output$QInteractionExpMed <- renderText({
    paste("<b> Do you want to isolate any interaction term", ifelse(input$Expo=="", "the exposure", input$Expo), "and", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),", </b> <br>
        i.e. If there is an interaction between the exposure and the mediator, do you want to highlight it in a separate term ?")})
  
  ###### Partie résumé des réponses #####
  output$VariableTypeMed <- renderTable({
    df <- data.frame("Variable" = c("Exposure", "Mediator (intermediate variable of interest)", "Outcome"),
               "Type" = c(input$TypExpMed, input$TypMediateurMed, input$TypOutcomeMed))
    SelectionMediation$VarType <- df
    df
  })
  
  # Contraintes sur les variables
  output$ContraintesMed <- renderTable({
    ExpRepet <- ifelse(input$ExpRepMed=="Yes", "Repeated", "Not repeated")
    MedRepet <- ifelse(input$MediateurRepMed=="Yes", "Repeated", "Not repeated")
    OutRepet <- ifelse(input$OutRepMed=="Yes", "Repeated", "Not repeated")
    df <- data.frame("Criterion" = c("Exposure", "Mediator", "Outcome"),
               "Response" = c(ExpRepet, MedRepet, OutRepet))
    SelectionMediation$ConstraintVar <- df
    df
  })
  
  # Contraintes sur les facteurs de confusion
  output$ContraintesMed2 <- renderTable({

    if((input$ObjMedA1=="Yes" || input$ObjMedA2=="Yes" || input$ObjMedA3=="Yes") 
       & (input$ObjMedB1=="No" & input$ObjMedB2=="No" & input$ObjMedB3=="No" & input$ObjMedB4=="No")){
      #On est dans le cas juste CDE, donc juste hyp 1 et 2 à vérifier donc moins de Q sur les facteurs de confusion
      df <- data.frame("Criterion" = "Unmeasured confounders",
                 "Response" = input$ConfuNonMesureMed)
      SelectionMediation$ConstraintConf <- df
      df
    }
    
    else{
      #On est dans le cas avec effets naturels et donc les 4 hyp à vérifiées -> toutes les Q sur les facteurs de confusion
      noms <- c("Unmeasured confounders",
              "Confounders of the mediator/outcome relationship affected by exposure")
      reponses <- c(input$ConfuNonMesureMed, input$ConfuInfluence)
      if(input$ConfuInfluence=="Oui"){
        noms <- c(noms, "Short time between exposure and measure of the mediator")
        reponses <- c(reponses, input$ShortTime)
        if(input$ShortTime=="No"){
          noms <- c(noms, "After adjustment, no unmeasured confounders of the mediator/outcome relationship")
          reponses <- c(reponses, input$add_hyp_cond)
        }
      }
      df <- data.frame("Criterion" = noms,
                "Response" = reponses)
      SelectionMediation$ConstraintConf <- df
      df
    }
  })
  
  # Contraintes sur la positivité
  output$ContraintesMed3 <- renderTable({
    noms <- c("Risk of positivity violation of the exposure (given confounders)",
              "Risque of positivity violation of the mediator (given confounders and exposure)")
    reponses <- c(input$PosiExpMed, input$PosiMedMed)
    df <- data.frame("Criterion" = noms,
               "Response" = reponses)
    SelectionMediation$ConstraintPos <- df
    df
  })
  
  # Terme d'interaction
  output$InteractionMed <- renderTable({
    noms <- "Interaction term"
    reponses <- input$InteractionExpMed
    if(input$InteractionExpMed=="No"){
      noms <- c(noms, "Interaction included in")
      reponses <- c(reponses, paste(input$InteractionDirIndir, "effect"))
    }
    df <- data.frame("Criterion" = noms,
               "Response" = reponses)
    SelectionMediation$Interaction <- df
    df
  })
  
  # Objectifs
  output$ObjectifResumeMed <- renderUI({
    exposition <- ifelse(input$Expo=="", "the exposure", input$Expo)
    mediateur <- ifelse(input$Mediateur=="", "the mediator", input$Mediateur)
    outcome <- ifelse(input$Outcome=="", "the outcome", input$Outcome)
    texte <- "<ul>"
    if(input$question1=="Yes"){texte <- paste(texte, " <li> Effect of", exposition, "on", outcome, "</li>")}
    if(input$ObjMedA1=="Yes"){texte <- paste(texte, "<br/> <li> Effect of", exposition, "on", outcome, "after implementation of an intervention affecting", mediateur, "</li>")}
    if(input$ObjMedA2=="Yes"){texte <- paste(texte, "<br/> <li> Effect of", exposition, "on", outcome, "if", mediateur, "was completely removed </li>")}
    if(input$ObjMedA3=="Yes"){texte <- paste(texte, "<br/> <li> •	Proportion of the effect of", exposition, "on", outcome, "that could be eliminated by removing", mediateur, "for all individuals", "</li>")}
    if(input$ObjMedB1=="Yes"){texte <- paste(texte, "<br/> <li> Effect of", exposition, "on", outcome, "that goes through", mediateur, "</li>")}
    if(input$ObjMedB2=="Yes"){texte <- paste(texte, "<br/> <li> Effect of", exposition, "on", outcome, "that does not go through", mediateur, "</li>")}
    if(input$ObjMedB3=="Yes"){texte <- paste(texte, "<br/> <li> Effect of", exposition, "on", outcome, "if all individuals had", mediateur, " value of a given", exposition,  " category </li>")}
    if(input$ObjMedB4=="Yes"){texte <- paste(texte, "<br/> <li> Proportion of the effect of", exposition, "on", outcome, "due to the effect of", exposition, "on", mediateur, "</li>")}
    texte <- paste(texte, "</ul>")
    SelectionMediation$Obj <- texte
    HTML(texte)
  })
  
}