#
#'Shiny app to view covid data from johns hopkins
#'peernisse@gmail.com
#'

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("COVID-19 USA"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(

        h3('Filter States')
        
        ),#end sidebar panel
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   
   #Data setup
  source('dataSetup.R')
  
  #Make time series plot
  gdata<-usDataL %>% 
    filter(Parameter=='Confirmed',
           Result>0 & Result != '')
  
  n<-length(unique(gdata$Province_State))
  
  g<-ggplot(gdata,aes(Date,Result,color=Province_State))+
    theme(plot.margin = margin(0.5,0.1,0.1,0.1,unit = 'in'))+
    geom_line()+
    theme(legend.position='None')+
    scale_color_manual(values = rep('grey',n))+
    labs(y='# of Cases',title = 'Cases through Time by State/Province')
  
  ggplotly(g) %>% 
    layout(hoverlabel=list(bgcolor="red")) %>% 
    highlight(on = "plotly_hover")
  
}#End server

# Run the application 
shinyApp(ui = ui, server = server)

