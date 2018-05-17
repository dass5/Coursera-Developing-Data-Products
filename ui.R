library(shiny)

data(mtcars)

list=names(mtcars)
#mylist=list[!list %in% c('mpg','vs','am','cyl','qsec','carb','gear')]

mylist=list[!list %in% c('mpg','vs','am','carb','gear')]

shinyUI(fluidPage(
  navbarPage("Mtcars data analysis and MPG prediction",
     tabPanel("Data Analysis",
    sidebarLayout(
      sidebarPanel(
      selectInput("var1","Select Variable",choices = mylist),
      selectInput("trans", "Select transmission:",
                  c(" " = 2,
                    "Manual" = 1,
                    "Automatic" = 0
                    ),
                    selected = NULL ,
                    multiple = F
                  ),
      submitButton("Submit"),
    #  verbatimTextOutput("id1")
      
    
    h5(textOutput("doc"))

    ),
   
    mainPanel(
      h3(textOutput("caption")),
      tabsetPanel(type = "tabs",
      tabPanel("Scatterplot", br(), plotOutput("scatterplot")),
      tabPanel("Boxplot", br(), plotOutput("boxplot")),
     tabPanel("Data", br(), tableOutput("results"))
              )
)
) 
),


  
 
tabPanel("Prediction Model", fluid = TRUE,
        sidebarLayout(
          sidebarPanel(
            
            selectInput("id1", "Select transmission:",
                        c("Manual" = 1,
                          "Automatic" = 0
                        )),
          sliderInput("id2", 'Enter qsec of the car', min = 1.1, max = 30.1, value = 1.1),
          sliderInput("id3", 'Enter weight of the car', min = 1.1, max = 6.1, value = 1.1),
          
          submitButton("Submit"),
h5(textOutput("preddoc"))

         ),
          mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("ModelSummary", br(), verbatimTextOutput ("summary")),
                        tabPanel("VarImp", br(), verbatimTextOutput ("varimp")),
                        tabPanel("Prediction", br(),textOutput("pred2")))
           # plotOutput("plot1"),
        #    h3('Prediction of horse power from mpg'),
         #   h4('Model 1'),
          #  textOutput("pred1"),
         #   h4('Model 2'),
         #   textOutput("pred2")
            
          )
)
)
)
)
)


 

