observe_events_Recommandations <- function(input, output, session, currentPage, values, SelectionMediation){
  
  #Button Prev après les recommandations
  observeEvent(input$Recommandation_Prev, {
    currentPage(ResumeMed)
  })
  
  # Quantités à estimer: fonction qui retourne un tableau avec tous les effets possibles et TRUE ou FALSE selon qu'ils soient à estimer ou non, ainsi que l'abréviation utilisée pour les sections suivante
  Estimands <- reactive({
    TotalEffect <- !is.null(values$question1) & values$question1=="Yes"
    
    CDE <- !is.null(input$question2) & (!is.null(input$ObjMedA1) | !is.null(input$ObjMedA2))&
      values$question2=="Yes" & (values$ObjMedA1 == "Yes" | values$ObjMedA2=="Yes")
    
    PropEliminated <- !is.null(values$question2) & !is.null(values$ObjMedA3) & values$question2=="Yes" & values$ObjMedA3=="Yes"
    
    NDE <- !is.null(values$question2) & (!is.null(values$ObjMedB2) | !is.null(values$ObjMedB3))&
      values$question2=="Yes" & (values$ObjMedB2 == "Yes" | values$ObjMedB3=="Yes")
    
    NIE <- !is.null(values$question2) & !is.null(values$ObjMedB1) & values$question2=="Yes" & values$ObjMedB1=="Yes"
    
    PropMediated <- !is.null(values$question2) & !is.null(values$ObjMedB4) & values$question2=="Yes" & values$ObjMedB4=="Yes"
    
    if(PropMediated==T) NIE <- TotalEffect <- T  # On a besoin de ces mesures pour calculer PropMediated
    if(PropEliminated==T) CDE <- TotalEffect <- T # On a besoin de ces mesures pour calculer PropEliminated
    
    if(input$InteractionExpMed=="Yes" & (NDE==T | NIE==T)){
      # On isole le terme d'interaction
      MIE = T
      
      if(NDE==T){
        PNDE <- T
        TNDE <- F
      }
      else {
        PNDE <- F
        TNDE <- F
      }
      if(NIE==T){
        PNIE <- T
        TNIE <- F
      }
      else {
        PNIE <- F
        TNIE <- F
      }
    }
    else if(input$InteractionExpMed=="No" & (NDE==T | NIE==T)){
      # On n'isole pas le terme d'interaction
      MIE = F
      
      if(input$InteractionDirIndir=="Direct"){
        if(NDE==T){
          TNDE <- T
          PNDE <- F
        }
        else{TNDE <- PNDE <- F}
        if(NIE==T){
          PNIE <- T
          TNIE <- F
        }
        else{PNIE <- TNIE <- F}
      }
      else{ # input$InteractionDirIndir ="Indirect"
        if(NDE==T){
          PNDE <- T
          TNDE <- F
        }
        else{TNDE <- PNDE <- F}
        if(NIE==T){
          TNIE <- T
          PNIE <- F
        }
        else{PNIE <- TNIE <- F}
      }
    }
    else{PNDE <- TNDE <- PNIE <- TNIE <- MIE <- F}
    
    
    Estimands <- data.frame(
      Effect = c("Total effect", "Controlled direct effect", "Proportion eliminated", "Pure natural direct effect", "Total natural direct effect",
                "Pure natural indirect effect", "Total natural direct effect", "Proportion mediated", "Mediated interactive effect"),
      Abbreviation = c("TE", "CDE", "PropEliminated", "PNDE", "TNDE", "PNIE", "TNIE", "PropMediated", "MIE"),
      Estimation = c(TotalEffect, CDE, PropEliminated, PNDE, TNDE, PNIE, TNIE, PropMediated, MIE),
      Objective = c("Effect of the exposure on the outcome",
                    "Effect of the exposure on the outcome after implementation of an intervention affecting the mediator \n
                     Effect of the exposure on the outcome if the mediator was completely removed",
                    "Proportion of the effect of the exposure on the outcome that could be eliminated by removing the mediator for all individuals",
                    "Effect of the exposure on the outcome that does not go through the mediator",
                    "Effect of the exposure on the outcome that does not go through the mediator",
                    "Effect of the exposure on the outcome that goes through the mediator",
                    "Effect of the exposure on the outcome that goes through the mediator",
                    "Proportion of the effect of the exposure on the outcome due to the effect of the exposure on the mediator",
                    "")
    ) 
    
  })
  
  # Estimands to be estimated
  Estimands_esti <- reactive({
    # Note: on utilise renderDT pour pouvoir afficher les retours à la lignes dans la colonnes "objectifs"
    # Comme je veux afficher un tableau simple sans toutes les options proposées par renderDT, je les supprime en les mettant FALSE
    
    Estimands <- Estimands() %>% 
      dplyr::filter(Estimation==T) %>%  # On filtre les effets qui sont à estimer
      dplyr::select((-Estimation))
    
    datatable(Estimands, escape = FALSE, rownames = FALSE, options = list(paging = F,
                                                                          searching=F,
                                                                          info=F,
                                                                          ordering = F,
                                                                          columnDefs = list(list(
                                                                            targets = "_all",
                                                                            render = JS(
                                                                              "function(data, type, row, meta) {",
                                                                              "  if(type === 'display') {",
                                                                              "    return data.replace(/\\n/g, '<br>');",
                                                                              "  } else {",
                                                                              "    return data;",
                                                                              "  }",
                                                                              "}"
                                                                            )
                                                                          ))))
  })
  
  # Output de la section Estimand
  output$Estimands <- renderDT({
    Estimands_esti()
 })
  
  ###### PArtie Décomposition #######
  ## Texte à afficher pour la décomposition 
  Decomp_Fct <- reactive({
    Estimands <- Estimands() %>%
      dplyr::filter(Estimation==T)
    
    AEstimer <- as.vector(Estimands$Abbreviation)
    Decomp <- ""
    
    if("TNIE" %in% AEstimer | "TNDE" %in% AEstimer) Decomp <- "<b>2-way decomposition :</b>"
    else if("PNDE"%in%AEstimer & "PNIE"%in%AEstimer) Decomp <- "<b>3-way decomposition :</b>"
    else if(("PNDE"%in%AEstimer | "PNIE"%in%AEstimer) & !("MIE"%in%AEstimer)) Decomp <- "<b>2-way decomposition :</b>"
    else if (("PNDE"%in%AEstimer | "PNIE"%in%AEstimer) & "MIE" %in% AEstimer) Decomp <- "<b>3-way decomposition :</b>"
    
    if("TNIE" %in% AEstimer | ("PNDE" %in% AEstimer & !("MIE" %in% AEstimer))){
      Decomp <- paste(Decomp, "$$TE = TNIE + PNDE$$")
      if(!("TNIE"%in%AEstimer)) Decomp <- paste(Decomp, "where TNIE is the total natural indirect effect <br> <br>")
      else if(!("PNDE"%in%AEstimer)) Decomp <- paste(Decomp, "where PNDE is the pure natural direct effect <br> <br>")
    }
    
    else if("TNDE" %in% AEstimer | ("PNIE" %in% AEstimer & !("MIE" %in% AEstimer))){
      Decomp <- paste(Decomp, "$$TE = TNDE + PNIE$$")
      if(!("TNDE"%in%AEstimer)) Decomp <- paste(Decomp, "where TNDE is the total natural direct effect <br> <br>")
      else if(!("PNIE"%in%AEstimer)) Decomp <- paste(Decomp, "where PNIE is the pure natural indirect effect <br> <br>")
    } 
    
    else if(Decomp=="<b>3-way decomposition :</b>"){
      Decomp <- paste(Decomp, "$$TE = PNDE + PNIE + MIE$$")
      if(!("PNDE"%in%AEstimer)) Decomp <- paste(Decomp, "where PNDE is the pure natural direct effect <br> <br>")
      else if(!("PNIE"%in%AEstimer)) Decomp <- paste(Decomp, "where PNIE is the pure natural indirect effect <br> <br>")
    } 
    
    if("PropEliminated" %in% AEstimer){
      Decomp <- paste(Decomp, "<br> <b>Proportion eliminated :</b> <br> <span style='margin-left: 50px;'> Additive scale : </span> $$\\frac{TE - CDE}{TE}$$
                       <br> <span style='margin-left: 50px;'> Relative risk scale : </span> $$\\frac{OR^{TE} - OR^{CDE}}{OR^{TE}-1}$$")
    }
    if("PropMediated" %in% AEstimer){
      # Le choix de l'effet direct (PNDE ou TNDE) et indirect dépendent des réponses
      if("TNIE" %in% AEstimer){
        Decomp <- paste(Decomp, "<br> <b>Proportion mediated :</b> <br> <span style='margin-left: 50px;'> Additive scale : </span> $$\\frac{TNIE}{TE}$$
                        <br> <span style='margin-left: 50px;'> Relative risk scale : </span> $$\\frac{OR^{PNDE}(OR^{TNIE}-1)}{OR^{PNDE}OR^{TNIE}-1}$$")
      }
      
      else{ #PNIE
        Decomp <- paste(Decomp, "<br> <b>Proportion mediated :</b> <br> <span style='margin-left: 50px;'> Additive scale : </span> $$\\frac{PNIE}{TE}$$")
        #Then we must differentiate PNDE and TNDE
        if("PNDE"%in% AEstimer){
          Decomp <- paste(Decomp, "<br>  <span style='margin-left: 50px;'> Relative risk scale : </span> $$\\frac{OR^{PNDE}(OR^{PNIE}-1)}{OR^{PNDE}OR^{PNIE}-1}$$")
        }
        else{ #TNDE
          Decomp <- paste(Decomp, "<br>  <span style='margin-left: 50px;'> Relative risk scale : </span> $$\\frac{OR^{TNDE}(OR^{PNIE}-1)}{OR^{TNDE}OR^{PNIE}-1}$$")
        }
      }
    }
    Decomp
  })
  
  ## Output pour la décomposition
  output$DecompEffet <- renderUI({
    Decomp <- Decomp_Fct()
    withMathJax(HTML(Decomp))
  })
  
  # output$DecompEffet <- renderUI({
  #   Estimands <- Estimands() %>%
  #     dplyr::filter(Estimation==T)
  # 
  #   AEstimer <- as.vector(Estimands$Abbreviation)
  # 
  #   if("TNIE" %in% AEstimer | "TNDE" %in% AEstimer)
  #     Decomp <- "<br> 2-way decomposition :"
  #   else if("PNDE"%in%AEstimer & "PNIE"%in%AEstimer) Decomp <- "<br> 3-way decomposition :"
  # 
  #   if("TNIE" %in% AEstimer){
  #     Decomp <- paste(Decomp, "<br> <math> TE = TNIE + PNDE </math>")
  #   }
  #   else if("TNDE" %in% AEstimer) Decomp <- paste(Decomp, "<br> <math> TE = TNDE + PNIE </math>")
  #   else if(Decomp=="3-way decomposition :") Decomp <- paste(Decomp, "<br> <math> TE = PNDE + PNIE + MIE </math>")
  # 
  #   if("PropEliminated" %in% AEstimer){
  #     Decomp <- paste(Decomp, "<br> Proportion éliminée : <br> Echelle additive : $$(TE - CDE)/TE$$
  #                     <br> Echelle risque relatif : <math display='block'> <mfrac> <mn> <var>OR <sup> TE</sup></var> - <var>OR<sup>CDE</sup></var></mn> <mn><var>OR<sup>TE</sup></var></mn> </mfrac></math>")
  #   }
  # 
  #   HTML(Decomp)
  # })
  
  ###### PArtie Méthode ######
  
  # Fonction qui retourne la méthode générale
  Methode <- reactive({
    if(input$ExpRepMed == "No" & input$MediateurRepMed=="No" & input$OutRepMed=="No"){
      Method <- "Regressions"
    }
    else if(input$OutRepMed=="No"){
      Method <- "G-methods"
    }
    else(
      Method <- "G-methods or mixed model (fixed effects model)"
    )
    Method
  })
  
  # Fonction qui retourne le texte complet de la recommandation de la méthode
  Method_full_txt_Med <- reactive({
    Method <- Methode()
    
    # Si g-méthode, on propose les méthodes
    if (Method=="G-methods"){
      if(input$TypExpMed=="Continuous" | input$TypMediateurMed=="Continuous"){
        Method <- paste(Method, ": given that your exposure and/or your mediator are continuous, the easiest is to use <b>g-computation</b>")
      }
      else{
        Method <- paste("<b>", Method, "</b>: specifically g-computation or marginal structural models
                        <br> For a more robust estimate, you can use a doubly robust estimator such as the TMLE (Targeted Maximum Likelihood Estimator).")
      }
      #Si outcome binaire ou continu on peu proposé les modèles naturel
      if (input$TypOutcomeMed=="Binary" | input$TypOutcomeMed=="Continuous"){
        Method <- paste(Method, "<br> <br> You can also use natural effect models.")
        
      } 
    }
    
    # Si outcome binaire et pas rare pas de régression logistique
    if(Method=="Regressions" && input$TypOutcomeMed=="Binary" && input$RareOutcome=="No"){
      Method <- paste(Method, "<br> In the second regression (outcome explained by the exposure, mediator and confounders), although your outcome is binary, you cannot perform a logistic regression because this is only valid in the case of a rare outcome (because of the non-collapsibility of the odds ratios). 
                      Instead, you can fit a log-linear or log-binomial regression.  <br> If you prefer, you can use g-methods instead of classical regressions. You can apply them from a logistic regression.")
    }
    
    # Si outcome survie et pas rare pas de régression de Cox
    if(Method=="Regressions" && input$TypOutcomeMed=='Survival / Time-to-event' && input$RareOutcome=="No"){
      Method <- paste(Method, "<br> In the second regression (outcome explained by the exposure, mediator and confounders), although your outcome is survival, you cannot perform a Cox regression because this is only valid in the case of a rare outcome (because of the non-collapsibility of hazard-ratio). 
                      Instead, you can fit an accelerated failure time model. <br> If you prefer, you can use g-methods instead of classical regressions. You can apply them from a Cox regression.")
    }
    
    if(Method=="G-methods or mixed model (fixed effects model)"){
      Method <- paste("<b>", Method, "</b> :",
                      "<br> <br> We advise you to keep only the last measure of your outcome and to apply a g-method. This will allow the causal dynamics to be taken into account, which is not possible with a mixed model. However, this is at the expense of taking account of constant unmeasured confounders. A mixed model will make it possible to take account of unmeasured constant effects but will not take account of causal dynamics, so your results will probably be biased.
                      <br> For more details, check <a href = https://onlinelibrary.wiley.com/doi/full/10.1111/ajps.12417 target='_blank'> Imai, K., & Kim, I. S. (2019). <i>When should we use unit fixed effects regression models for causal inference with longitudinal data?. American Journal of Political Science,</i> 63(2), 467-490.</a> 
                      <br> and <a href = https://imai.fas.harvard.edu/research/files/FEmatch-twoway.pdf target='_blank'> Imai, K., & Kim, I. S. (2021). <i>On the use of two-way fixed effects regression models for causal inference with panel data. Political Analysis,</i> 29(3), 405-415.</a> 
                      ")
    }
    
    # Probleme de non positivité évidente
    # if(input$PosiExpMed=="Oui" | input$PosiMedMed=="Oui"){
    #   Method <- paste(Method,
    #                   "<br> <br> L'hypothèse de positivité nécéssaire à l'analyse de médiation est violée, <b> vos résultats seront donc probablement biaisés et imprécis </b>. <br>
    #                   Nous recommandons, si vous souhaitez tout de même faire l'analyse de faire de la <b> g-computation </b>, mais vous devrez rester très prudent dans l'interprétation des résultats. Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, la g-computation extrapole sur des combinaisons impossibles. Si le problème est dû à l'échantillon, le g-computation extrapole les résultats sans avoir de données, le résultats risque donc d'être imprécis.")
    # }
    return(Method)
  })
  
  
  ## Output de la section Méthode recommandée
  output$MethodeRecommandee <- renderUI({
    Method <- Method_full_txt_Med()
    HTML(Method)
  })
  
  
  ### Assumptions ###
  ## texte à afficher pour les hypothèses 
  Assumptions_Med_Fct <- reactive({
    Estimands <- Estimands() %>%
      dplyr::filter(Estimation==T)
    AEstimer <- as.vector(Estimands$Abbreviation)
    
    # Cas où l'on estime des effets naturels: il faut les 4 hypothèses
    if("PNIE" %in% AEstimer | "TNIE"%in% AEstimer | "PNDE"%in% AEstimer | "TNDE"%in% AEstimer){
      Hyp <- "1- No unmeasured / uncontrolled confounders of the exposure/outcome relationship  <br>
      2- No unmeasured / uncontrolled confounders of the mediator/outcome relationship  <br>
      3- No unmeasured / uncontrolled confounders of the exposure/mediator relationship  <br>
      4- No confounders of the mediator/outcome relationship that is a consequence of exposure  <br>
      In addition : positivity and consistency"
      
      if("CDE" %in% AEstimer){
        Hyp <- paste(Hyp, "<br> <br> For the controlled direct effect and the eliminated proportion, only the first two hypotheses (as well as positivity and consistency) are required.")
      }
      
      Hyp <- paste(Hyp, "<br> <br> <b> Verification of these assumptions in your data :</b>")
      
      # Facteurs de confusion non mesurés
      if(input$ConfuNonMesureMed=="Yes"){
        Hyp <- paste(Hyp, "<br> <br> You indicated that some confounding factors are unmeasured in your data. Once you have done your analysis, you can perform sensitivity analyses to estimate how sensitive your results are to these unmeasured factors.")
      }
      else{
        Hyp <- paste(Hyp, "<br> <br> You indicated that there are no unmeasured confounders in your data. If you adjust for all of them and if you have not forgotten any, assumptions 1, 2 and 3 are therefore verified. 
                     However, think carefully, as it seems unlikely that there are no unmeasured confounders in social epidemiology. <br>
                     If you finally think you may have some unmeasured confounders, you can carry out sensitivity analyses to try to estimate how sensitive your results are to these unmeasured factors.")
      }
      
      # Verif hypothèse 4: cas non valide
      if(input$ConfuInfluence=="Yes"){
        Hyp <- paste(Hyp, "<br> <br> You indicated that at least one of the confounders in the mediator/outcome relationship is influenced by the exposure. Assumption 4 is therefore violated.")
        
        if(input$ShortTime=="Yes"){
          Hyp <- paste(Hyp, "<br> However, the time between the observation of the exposure and that of the mediator is short, so it is possible to hypothesise that the mediator does not have time to be influenced by this confounder itself influenced by the exposure. 
                       In this case, assumption 4 may be considered not violated.")
        }
        else if(input$add_hyp_cond=="Yes"){
          Hyp <- paste(Hyp, "<br> In your opinion, conditional on exposure, mediator and intermediate confounder, there is no unmeasured confounder of the mediator-outcome relationship.
                       Using the methods indicated above, you can still estimate causal effects, but these will be randomised interventional effects and not conditional or marginal effects, so their interpretation will be slightly different.")
        }
        else{
          Hyp <- paste(Hyp, "<br> <br> According to your answers, assumption 4 is not verified. If you do the analysis, <b> your results will probably be biased </b>.")
        }
      }
      
      # Verif hypothèse 4: cas valide
      else{
        Hyp <- paste(Hyp, "<br> <br> You indicated that no confounder of the mediator/outcome relationship is influenced by the exposure. If this is correct, assumption 4 would therefore be verified.")
      }
    }
    
    # Cas où l'on estime que l'effet direct contrôlé ou la proportion éliminée
    else{
      Hyp <- "1- No unmeasured / uncontrolled confounder of the exposure/outcome relationship  <br>
      2- No unmeasured / uncontrolled confounder of the mediator/outcome relationship  <br>
    In addition : Positivity and consistency"
      Hyp <- paste(Hyp, "<br> <br> <b> Verification of these assumptions in your data :</b>")
      
      # Verif hyp 1 et 2
      if(input$ConfuNonMesureMed=="Yes"){
        Hyp <- paste(Hyp, "<br> <br> You indicated that some confounders are unmeasured in your data. Once you have done your analysis, you can perform sensitivity analyses to estimate how sensitive your results are to these unmeasured factors.")
      }
      else{
        Hyp <- paste(Hyp, "<br> <br> You indicated that there are no unmeasured confounders in your data. If you adjust for all of them and if you have not forgotten any, assumptions 1 and 2 are therefore verified. 
                     However, think carefully, as it seems unlikely that there are no unmeasured confounders in social epidemiology. <br>
                     If you think you may have some unmeasured confounders, you can carry out sensitivity analyses to try to estimate how sensitive your results are to these unmeasured factors.")
      }
    }
    
    # Vérif positivité
    if(input$PosiExpMed=="Yes" | input$PosiMedMed=="Yes"){
      Hyp <- paste(Hyp, "<br> <br> The positivity assumption may be violated")
      if (Methode()=="Regressions"){
        Hyp <- paste(Hyp, "<br> <b> your results will therefore probably be biased and inaccurate </b>. <br>
                     Regression models will extrapolate results. 
                     If the problem of non-positivity is due to a theoretically impossible combination, the regression extrapolates on impossible / non-existent combinations. If the problem is due to the sample, it extrapolates results without having any data, so they are likely to be imprecise.")
      }
      else{
        Hyp<- paste(Hyp, "<br> <b> your results will therefore probably be biased and inaccurate </b>. <br>
                      If you still want to do the analysis, we recommend using <b> g-computation </b>. 
                    However, you need to be very careful when interpreting the results. If the positivity problem is due to a theoretically impossible combination, g-computation extrapolates on impossible / non-existent combinations. If the problem is due to the sample, g-computation extrapolates results without having any data, so they are likely to be imprecise.")
      }
    }
    else if(input$PosiExpMed=="I don't know" | input$PosiMedMed=="I don't know"){
      Hyp <- paste(Hyp, "<br> <br> You indicated that you do not know whether there is a risk of positivity violation. To get an idea, you can draw up two contingency tables: 1) a combination of confounders / exposure and 2) a combination of confounders and exposure / mediators. If certain boxes are equal to 0, then the positivity assumption is violated.")
    }
    else{
      Hyp <- paste(Hyp, "<br> <br> In your opinion, the positivity assumption is verified.")
    }
  })
  
  ## Output pour les hypothèses
  output$AssumptionsMed <- renderUI({
    Hyp <- Assumptions_Med_Fct()
    HTML(Hyp)
  })
  
  ### Partie packages ###
  ## Texte à afficher pour la partie Package
  Packages_Med_Fct <- reactive({
    if(Methode()=="Regressions"){
      if(input$TypOutcomeMed=="Binary" && input$RareOutcome=="No"){
        Pac <- "You can fit the first regression with R base <i>lm()</i> or <i>glm()</i> function.
        For the second regression (outcome explained by exposure and mediator), you can use the <i>glm()</i> function with <i> family = binomial(link='log')</i> or the <i> logbin()</i> function from the package of the same name. <br>
        There can sometimes be convergence problems with the <i>glm </i> that are resolved using the <i>logbin()</i> one. However, the latter does not allow interaction terms to be included directly in the model. 
        To include an interaction the variables corresponding to the interaction must be created outside the model. So, if there are no convergence problems, it's simpler to use the glm() function. <br> <br>
        
        You can then do the calculations by hand using the coefficients from both regressions.
      <br> <br>
      Another possibility is to use the <i>cmest()</i> function in the <i> CMAverse </i> package, choosing the <i> rb </i> (regression-based approach) model and the <i> yreg = 'loglinear'</i> argument. This will directly return the estimates."
      }
      else if(input$TypOutcomeMed=='Survival / Time-to-event' && input$RareOutcome=="Yes"){
        Pac <- "You can fit the first regression with R base <i>lm()</i> or <i>glm()</i> function.
        For the second regression (outcome explained by exposure and mediator), you can use the <i>coxph()</i> function in the <i> Survival </i> package<br>
        You can then do the calculations by hand using the coefficients from both regressions. <br>
        <br>
        Another possibility is to use the <i>cmest()</i> function in the <i> CMAverse </i> package, choosing the <i> rb </i> (regression-based approach) model and the <i> yreg = 'coxph'</i> argument. This will directly return the estimates."
      }
      
      else if(input$TypOutcomeMed=='Survival / Time-to-event' && input$RareOutcome=="No"){
        Pac <- "You can use the <i> cmest()</i> function from the <i> CMAverse </i> package, choosing the <i> rb </i> (regression-based approach) model and the <i> yreg='aft_exp'</i> or <i> yreg='aft_weibull'</i> argument."
      }
      else{
        Pac <- "You can fit the two regressions with the R base <i>lm()</i> or <i>glm()</i> functions and then do the calculations by hand using the coefficients from both regressions.
      <br> <br>
      Another possibility is to use the <i>cmest()</i> function in the <i> CMAverse </i> package, choosing the <i> rb </i> (regression-based approach) model </i>. This will directly return the estimates."
      }
      Pac <- paste(Pac, "<br> <br> For more details about how to use the <i> CMAverse </i> package : 
                   <a href = https://bs1125.github.io/CMAverse/index.html target = '_blank'> https://bs1125.github.io/CMAverse/index.html </a>")
    }
    
    else{
      Pac <- "You can use the <i> cmest()</i> function in the <i> CMAverse </i> package <br>
      Marginal structural model : choose <i>model = msm </i> 
      <br> G-computation : choose <i>model = gformula </i>
      <br> For a more robust estimate, you can use the TMLE method (targeted maximum likelihood estimation). You can do it using the<i> tmle </i> package.
      <br> <br> <i> Note : </i> msm model is not implemented for a continuous exposure or mediator."
      if((input$TypOutcomeMed=="Binary" | input$TypOutcomeMed=="Continuous")){
        Pac <- paste(Pac, "
                     <br> <br>  Natural effect model : <i> CMAverse </i> package choosing <i> model = ne </i> in the <i> cmest() </i> function. ")
      }
    }
    Pac
  })
  
  ## Output de la partie Package
  output$PackagesMed <- renderUI({
    Pac <- Packages_Med_Fct()
    HTML(Pac)
  })
  
  
  ### Téléchargement des recommandations au format html
  output$report_Med <- downloadHandler(
    filename = "Recommandations.html",
    content = function(file){
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "Recommandations_Med.Rmd")
      file.copy("Recommandations_Med.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      Obj <- SelectionMediation$Obj
      Estimands <- Estimands_esti()
      Decomp <- Decomp_Fct()
      Method <- Method_full_txt_Med()
      Hyp <- Assumptions_Med_Fct()
      Pac <- Packages_Med_Fct()
      params <- list(Objective = HTML(Obj),
                     VarType = SelectionMediation$VarType,
                     ConstraintVar = SelectionMediation$ConstraintVar,
                     ConstraintConf = SelectionMediation$ConstraintConf,
                     ConstraintPos = ConstraintPos <- SelectionMediation$ConstraintPos,
                     Interaction = SelectionMediation$Interaction,
                     Estimands = Estimands, 
                     Decomposition = withMathJax(HTML(Decomp)),
                     Methodes = HTML(Method), 
                     Assumptions = HTML(Hyp), 
                     Packages = HTML(Pac))
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  # ### Réinitialisation du questionnaire
  # observeEvent(input$Reinitialisation_Med, {
  #   values$question1 = NULL
  #   values$question2 = NULL             
  #   
  #   # Effet total                
  #   values$ExpoTot = ""
  #   values$OutTot = ""               
  #   values$TypExpTot = NULL 
  #   values$TypOutcomeTot = NULL           
  #   values$ConfuTot = NULL
  #   values$ConfuNonMesureTot = NULL                  
  #   values$MedExpOutTot = NULL
  #   values$CollidExpOutTot = NULL             
  #   values$ExpRepTot = NULL
  #   values$ConfRepTot = NULL
  #   values$OutRepTot = NULL                        
  #   values$QPosiTot = NULL
  #   
  #   ##Médiation                
  #   values$Expo = "" 
  #   values$Mediateur = "" 
  #   values$Outcome=""                     
  #   values$ObjMedA1 = NULL
  #   values$ObjMedA2 = NULL
  #   values$ObjMedA3 = NULL #ObjMedA0 = NULL,                      
  #   values$ObjMedB1 = NULL 
  #   values$ObjMedB2 = NULL 
  #   values$ObjMedB3 = NULL 
  #   values$ObjMedB4 = NULL                       
  #   values$TypExpMed = NULL 
  #   values$TypMediateurMed = NULL 
  #   values$TypOutcomeMed = NULL 
  #   values$EffetTotVerif = NULL 
  #   values$RareOutcome=NULL                  
  #   values$ExpRepMed = NULL 
  #   values$MediateurRepMed = NULL 
  #   values$OutRepMed = NULL                 
  #   values$ConfuExpOutMed = NULL
  #   values$ConfuExpMedMed = NULL 
  #   values$ConfuMedOutMed = NULL 
  #   values$ConfuNonMesureMed = NULL 
  #   values$ConfuInfluence = NULL              
  #   values$ShortTime = NULL 
  #   values$add_hyp_cond = NULL          
  #   values$CollidExpOutMediation = NULL 
  #   values$CollidMedOut = NULL                     
  #   values$PosiExpMed = NULL 
  #   values$PosiMedMed = NULL                         
  #   values$InteractionExpMed = NULL 
  #   values$InteractionDirIndir = NULL
  #   
  #   currentPage("Qprelim")
  # })
  
}

