## Server
observe_events_Objectifs <- function(input, output, session, currentPage, values){

# Display objective question (total effect or mediation)
observeEvent(input$block_prelim, {
  if (input$questionP == "Yes"){
    currentPage(Q1)
  }
  else{ # If no DAG, display pop up 
    shinyalert("No DAG", "This application assumes that you have already drawn your DAG. 
               If not, draw one before starting. If you need help, you'll find references in the 'Resources' tab.", type = "error")
  }
})

# If next, display "asking variable name if mediation is selected
observeEvent(input$EndObj1Next, {
  if(input$question1=="No" & input$question2=="No")  shinyalert("Undefined objective", "It seems that your research question does not match the scope of this app", type = "error")
  # update slected values
  values$question1 <- input$question1
  values$question2 <- input$question2
  # Next page
  if(input$question2=="Yes") {
    currentPage(Q2)
  }
  else if(input$question1=="Yes" & input$question2=="No"){
    currentPage(VarTot)
  } 
  
})

# If previous, display Dag question again
observeEvent(input$EndObj1Prev, {
  currentPage("Qprelim")
})

# If previous on page Q2, display Q1 again
observeEvent(input$EndObj2Prev, {
  currentPage(Q1)
})

# Button Next à la fin de Q2
observeEvent(input$EndObj2Next, {
  values$Expo <- input$Expo
  values$Mediateur <- input$Mediateur
  values$Outcome <- input$Outcome
  currentPage(MedA)
})

# Button Prev after mediation A questions
observeEvent(input$MedA_Prev, {
  currentPage(Q2)
})

# Button Next after mediation A questions
observeEvent(input$MedA_Next, {
  values$ObjMedA1 <- input$ObjMedA1
  values$ObjMedA2 <- input$ObjMedA2
  values$ObjMedA3 <- input$ObjMedA3
  currentPage(MedB)
})

# Button Prev after mediation B questions
observeEvent(input$MedB_Prev, {
  currentPage(MedA)
})

# Button Next after mediation B questions
observeEvent(input$MedB_Next, {
  values$ObjMedB1 <- input$ObjMedB1
  values$ObjMedB2 <- input$ObjMedB2
  values$ObjMedB3 <- input$ObjMedB3
  values$ObjMedB4 <- input$ObjMedB4
  if(values$ObjMedA1=="No" & values$ObjMedA2=="No" & values$ObjMedA3=="No" & values$ObjMedB1=="No" & values$ObjMedB2=="No" & values$ObjMedB3=="No" & values$ObjMedB4=="No"){
    shinyalert("Undefined objective", "It seems that your research question does not correspond to a mediation analysis. Please make sure that none of the proposed objectives are close to yours. \n
                If not, your intermediate variable may not be relevant to your problem. In this case, you might just want to consider a total effect analysis. For that purpose, enter 'yes' and then 'no' at the first questions about your objective")
    
    currentPage(Q1)
  }
  else{
    currentPage(TypVarMed)
  }
})

# Expo <- reactive({ifelse(input$Expo=="", "l'exposition", input$Expo)})
# Mediateur <- reactive({ifelse(input$Mediateur=="", "le facteur intermédiaire", input$Mediateur)})
# Outcome <- reactive({ifelse(input$Outcome=="", "l'outcome", input$Outcome)})

# Texte questions médiation A
# output$QMedA0 <- renderText({
#   paste("<b> Intervenir sur la variable intermédiaire <i>", input$Mediateur, " </i> pour mitiger/renforcer l'effet de l'exposition <i>", input$Expo,
#         "</i> sur l'outcome <i>", input$Outcome, "</i> </b>")
# })

output$QMedA1 <- renderText({
  paste("<b> To study the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "the outcome", input$Outcome),
        "after the implementation of an intervention/policy that affects",
        ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur), " </b>")
})

output$QMedA2 <- renderText({
  paste("<b> To study the effect of ",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "the outcome", input$Outcome),
        "if", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),
        "was completely eliminated </b>")
})

output$QMedA3 <- renderText({
  paste("<b> To study the proportion of the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "the outcome", input$Outcome),
        "that could be eliminated by removing",
        ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),
        "for all individuals </b>")
})

# Texte questions mediation B
output$QMedB1 <- renderText({
  paste("<b> To study the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "the outcome", input$Outcome),
        "that goes through ", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),
         "</b>")
})

output$QMedB2 <- renderText({
  paste("<b> To study the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "the outcome", input$Outcome), 
        "that does not go through ", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),
        "</b>")
})

output$QMedB3 <- renderText({
  paste("<b> To study the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "outcome", input$Outcome),
        "if all individuals had the" ,ifelse(input$Mediateur=="", "intermediate variable", input$Mediateur),
        "value of a given", ifelse(input$Expo=="", "exposure", input$Expo), "category </b> <br>
        e.g. if all individuals had the same value of", ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur),
        "as the exposed individuals")
})

output$QMedB4 <- renderText({
  paste("<b> To study the proportion of the effect of",  ifelse(input$Expo=="", "the exposure", input$Expo),
        "on", ifelse(input$Outcome=="", "outcome", input$Outcome),
        "that is due to the effect of", ifelse(input$Expo=="", "the exposure", input$Expo), "on",
        ifelse(input$Mediateur=="", "the intermediate variable", input$Mediateur), "</b>")
})



}