function(values){
  fluidRow(
    h3("Recommendations"),
    br(),
    p("According to the answers you provided"),
    column(12,
           wellPanel(
             h4("Estimands"),
             p("Total effect")
           )),
    
    
    column(12,
           wellPanel(
             h4("Estimation method"),
             htmlOutput("MethodeRecommandee_Tot")
           )),
    
    column(12,
           wellPanel(
             h4("Assumptions"),
             htmlOutput("Assumptions_Tot")
           )),
    
    column(12,
           wellPanel(
             h4("R packages"),
             htmlOutput("Packages_Tot")
           )),
    
    actionButton("Recommandation_Tot_Prev", "< Back"),
    downloadButton("report_tot", "Download"),
    actionButton("Reinitialisation", "Reset questionnaire")
  )
}