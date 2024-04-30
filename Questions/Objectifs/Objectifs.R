function(values){
div(class = 'container',
        h3("Is your objective :"),
    p("(The variables suggested in the following two sentences are only examples, and can be replaced by your own variables later on)"),
        radioButtons("question1", "To study the effect of social class on mortality",
                     choices = c("Yes", "No"),
                     selected = values$question1),
        br(),
    
    
    radioButtons("question2", "To study the role of tobacco as an intermediary between social class and mortality", 
                 choices = c("Yes", "No"), 
                 selected = values$question2),
    br(),
    actionButton("EndObj1Prev", "< Back"),
    actionButton("EndObj1Next", "Next >"),
    br()
    )
}

