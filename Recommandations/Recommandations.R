function(values){
  fluidRow(
    h3("Recommendations"),
    br(),
    p("According to the answers provided"),
    column(12,
           wellPanel(
             h4("Estimands"),
             DTOutput("Estimands")
           )),
    
    column(12,
           wellPanel(
             h4("Decomposition"),
             htmlOutput("DecompEffet")
           )),
    
    column(12,
           wellPanel(
             h4("Estimation method"),
             htmlOutput("MethodeRecommandee")
           )),
    
    column(12,
           wellPanel(
             h4("Assumptions"),
             htmlOutput("AssumptionsMed")
           )),
    
    column(12,
           wellPanel(
             h4("R packages"),
             htmlOutput("PackagesMed")
           )),
    
    actionButton("Recommandation_Prev", "< Back"),
    downloadButton("report_Med", "Download"),
    actionButton("Reinitialisation", "Reset questionnaire")
  )
}