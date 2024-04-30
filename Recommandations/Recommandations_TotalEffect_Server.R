observe_events_Recommandations_Tot <- function(input, output, session, currentPage, values, SelectionTotal){
  
  #Button Prev après les recommandations
  observeEvent(input$Recommandation_Tot_Prev, {
    currentPage(ResumeTot)
  })
  
  
  ###### PArtie Méthode ######
  #Fonction qui retourne la méthode générale la plus appropriée
  Methode <- reactive({
    if((input$ExpRepTot == "No" | (input$ExpRepTot=="Yes" & input$ConfRepTot=="No")) & input$OutRepTot=="No"){
      Method <- "Regression"
    }
    else if(input$OutRepTot=="No"){
      Method <- "G-methods"
    }
    else(
      Method <- "G-methods or mixed model (fixed effects model)"
    )
  })
  
  # Fonction qui retourne le texte complet de la recommandation de la méthode
  Methode_FullTxt <- reactive({
    Method <- Methode()
    if(Method=="Regression"){
      Method <- paste(Method, "or propensity score method (regression weighted by the inverse of the propensity score (IPW), matching, stratification). These methods enable to simulate a randomised trial.")
    }
    if(Method == "G-methods or mixed model (fixed effects model)"){
      Method <- paste("<b>", Method, "</b>",
                      "<br> <br> If the outcome at time <i>t</i> is not influenced by exposure at time <i>t-1</i> and the outcome at time <i>t</i> does not influence exposure at time <i>t+1</i>, and if in addition exposure at time <i>t</i> does not influence any confounding factors at time <i>t+1</i>, you can run a fixed-effects model. Beware though, this is a strong and unlikely assumption.<br>
                      For more details check <a href = https://onlinelibrary.wiley.com/doi/full/10.1111/ajps.12417 target='_blank'> Imai, K., & Kim, I. S. (2019). <i>When should we use unit fixed effects regression models for causal inference with longitudinal data?. American Journal of Political Science,</i> 63(2), 467-490.</a> 
                      <br> and <a href = https://imai.fas.harvard.edu/research/files/FEmatch-twoway.pdf target='_blank'> Imai, K., & Kim, I. S. (2021). <i>On the use of two-way fixed effects regression models for causal inference with panel data. Political Analysis,</i> 29(3), 405-415.</a> 
                      <br> Otherwise, consider keeping only the last outcome measure and using g-methods (g-computation or marginal structural models).")
      if(input$TypExpTot=="Continuous"){
        Method <- paste(Method, "Given that your exposure is continuous, the easiest way is to use <b>g-computation</b>.")
      }
    }
    if (Method=="G-methods"){
      if(input$TypExpTot=="Continuous"){
        Method <- paste(Method, ": given that your exposure is continuous, the easiest way is to use <b>g-computation</b>.")
      }
      else{
        Method <- paste("<b>", Method, "</b>: in particular g-computation or marginal structural models
                        <br> For a more robust estimate, you can use a doubly robust estimator such as the TMLE (Targeted Maximum Likelihood Estimator).")
      }
    }
    
    # Probleme de non positivité évidente
    if(input$QPosiTot=="Yes"){
      Method <- paste(Method,
                      "<br> <br> The positivity assumption necessary for causal analysis is violated, <b>so your results will probably be biased</b>.  <br>
                      If you still want to do the analysis anyway, we recommend that you use <b> g-computation </b>, but you will have to be very careful in interpreting the results")
    }
  })
  
  # Output de la partie méthode
  output$MethodeRecommandee_Tot <- renderUI({
    Method <- Methode_FullTxt()
    withMathJax(HTML(Method))
  })
  
  
  #### Partie Hypothèses ####
  
  ## Fonction qui retourne le texte a affiché dans la partie Hypothèses
  Assumptions_Tot_Fct <- reactive({
    Hyp <- "<b>1- Positivity:</b> each individual has a non-zero probability of being exposed / non-exposed  <br>
    <b>2- Ignorability / Exchangeability:</b> the value of the potential (counterfactual) outcome under exposure <i>a </i> is independent of the value of the actual value of exposure <br>
    <b>3- Non-interference:</b> one individual's outcome is not affected by the value of another individual's exposure  <br>
    <b>4- Consistency:</b> the potential (counterfactual) outcome of an individual under a certain exposure value corresponds to the value of the outcome it would have actually taken under this exposure<br>
     <br> <i>Note 1 : </i> These hypotheses can be formulated conditionally, i.e. by adding 'conditional on confounders'.  <br>
    <br> <i>Note 2 : </i> These hypotheses are difficult to test in practice."
    
    #Positivité
    if(input$QPosiTot=="Yes"){
      Hyp <- paste(Hyp, "<br> <br> You indicated that the positivity assumption is probably not verified in your data. <b>Your results are therefore likely to be biased and inaccurate. </b>")
      if(Methode()=="Regression"){
        Hyp <- paste(Hyp, "<br> A regression model will extrapolate the results.  
                     If the problem of non-positivity is due to a theoretically impossible combination, the regression extrapolates on impossible / non-existent combinations. If the problem is due to the sample, it extrapolates the results without having any data, so the results are likely to be imprecise.
                     <br> Concerning propensity scores, some values will be zero, which will imply a division by 0 when calculating the IPW and will therefore make it impossible. With matching, some individuals cannot be matched and will therefore not be taken into account in the analysis, which will result in a loss of information and could create a selection bias.  
                     <br> You can also use g-computation/standardization. But as with regression, this method will extrapolate the results, which may therefore be imprecise")
      }
      else{
        Hyp <- paste(Hyp, "<br> If you still want to do the analysis, we recommend to use <b> g-computation </b>. 
                    However, you need to be very careful when interpreting the results. If the positivity problem is due to the fact that a combination is theoretically impossible, g-computation extrapolates on impossible / non-existent combinations. If the problem is due to the sample, g-computation extrapolates the results without having any data, so the results are likely to be imprecise.")
      }
    }
    
    else if(input$QPosiTot == "I don't know"){
      Hyp <- paste(Hyp, "<br> <br> To get an idea of the positivity of your data, you can draw a contingency table with the possible combinations of confounders on one side and the exposure on the other. If none of the boxes contains a value of 0, the data is positive. The greater the number of characteristics (number of confounders and their levels) and the smaller the sample, the greater the risk of positivity violation.")
    }
    
    else{
      Hyp <- paste(Hyp, "<br> <br> You indicated that you do not suspect any problem linked to positivity.")
    }
    
    # Facteurs de confusion non mesurés
    if(input$ConfuNonMesureTot=="Yes"){
      Hyp <- paste(Hyp, "<br> <br> You indicated that you have unmeasured confounders, so your results may be biased.  
                   You can still carry out the analysis and then perform sensitivity analyses to try to estimate how sensitive your results are to these factors.")
    }
    else{
      Hyp <- paste(Hyp, "<br> <br> You indicated that you don't have any unmeasured confounder. 
      So, if you fit your model with all the measured confounders it should be correct. 
      However, think carefully about it as it seems unlikely to have access to all confounders you need in social epidemiology. 
      If you think you may have some unmeasured confounders, you can carry out sensitivity analyses to try to estimate how sensitive your results are to these unmeasured factors.")
    }
  })
  
  ## Output Hypothèses
  output$Assumptions_Tot <- renderUI({
    Hyp <- Assumptions_Tot_Fct()
    #sortie en format HTML
    HTML(Hyp)
  })
  
  ### Partie Packages
  ## Fonction qui retourne le texte de la partie Package
  Packages_Tot_Fct <- reactive({
    if (Methode()=="Regression"){
      Pac <- "Regression : fonctions of R base : <i> lm()</i> for continuous outcome or <i>glm()</i> for binary, categorical outcome. For a survival outcome you can use the <i>coxph()</i> function of the <i>survival</i> package.
      <br> Inverse Propensity Weighting :<i> WeightIt </i> package
      <br> Matching on inverse propensity weights: <i> MatchIt </i> package
      <br> Stratification : you can create strata using the R <i>Quintiles()</i> function
      <br>
      <br> You can also use standardization/g-computation. For this, use <i>stdReg</i> package"
    }
    else{
      Pac <- "G-computation/Standardization : manual code (see tutorial under the Rssources tab)
      <br> Marginal Structural Models (MSM) : use <i> WeightIt </i> package to get weights, then perform a regression on outcome on the exposure weighted by IPW"
    }
  })
  
  ## Output Package
  output$Packages_Tot <- renderUI({
    Pac <- Packages_Tot_Fct()
    HTML(Pac)
  })
  
  ### Téléchargement des recommandations au format html
  output$report_tot <- downloadHandler(
    filename = "Recommandations.html",
    content = function(file){
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "Recommandations_Tot.Rmd")
      file.copy("Recommandations_Tot.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      Obj <- SelectionTotal$Obj
      VarType <- SelectionTotal$VarType
      Cons <- SelectionTotal$Constraint
      Method <- Methode_FullTxt()
      Hyp <- Assumptions_Tot_Fct()
      Pac <- Packages_Tot_Fct()
      params <- list(Objective = HTML(Obj), VarType = VarType, Constraints = Cons,  Estimands = HTML("Total effect"), Methodes = withMathJax(HTML(Method)), Assumptions = HTML(Hyp), Packages = HTML(Pac))
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  ### Reinitialisation du questionnaire
  observeEvent(input$Reinitialisation, {
    showModal(modalDialog(
      title = "You are about to go back at the beginning of the questionnaire. Your answers won't be saved",
      footer = tagList(actionButton("Confirme_reinitialisation", "Confirm"),
                       modalButton("Cancel"))
      )
    )
  })
  
  observeEvent(input$Confirme_reinitialisation, {
    values$question1 = NULL
    values$question2 = NULL             
                             
    # Effet total                
    values$ExpoTot = ""
    values$OutTot = ""               
    values$TypExpTot = NULL 
    values$TypOutcomeTot = NULL           
    values$ConfuTot = NULL
    values$ConfuNonMesureTot = NULL                  
    values$MedExpOutTot = NULL
    values$CollidExpOutTot = NULL             
    values$ExpRepTot = NULL
    values$ConfRepTot = NULL
    values$OutRepTot = NULL                        
    values$QPosiTot = NULL
                                    
    ##Médiation                
    values$Expo = "" 
    values$Mediateur = "" 
    values$Outcome=""                     
    values$ObjMedA1 = NULL
    values$ObjMedA2 = NULL
    values$ObjMedA3 = NULL #ObjMedA0 = NULL,                      
    values$ObjMedB1 = NULL 
    values$ObjMedB2 = NULL 
    values$ObjMedB3 = NULL 
    values$ObjMedB4 = NULL                       
    values$TypExpMed = NULL 
    values$TypMediateurMed = NULL 
    values$TypOutcomeMed = NULL 
    values$EffetTotVerif = NULL 
    values$RareOutcome=NULL                  
    values$ExpRepMed = NULL 
    values$MediateurRepMed = NULL 
    values$OutRepMed = NULL                 
    values$ConfuExpOutMed = NULL
    values$ConfuExpMedMed = NULL 
    values$ConfuMedOutMed = NULL 
    values$ConfuNonMesureMed = NULL 
    values$ConfuInfluence = NULL              
    values$ShortTime = NULL 
    values$add_hyp_cond = NULL          
    values$CollidExpOutMediation = NULL 
    values$CollidMedOut = NULL                     
    values$PosiExpMed = NULL 
    values$PosiMedMed = NULL                         
    values$InteractionExpMed = NULL 
    values$InteractionDirIndir = NULL
    
    removeModal()
    currentPage("Qprelim")
  })
  
}