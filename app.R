library(shiny)
library(ggplot2)
library(DT)

# Interface utilisateur (UI)
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "minty"),
  titlePanel("Exploration des Diamants"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "color_rose", 
                   label = "Colorier les points en rose ?", 
                   choices = c("Oui" = TRUE, "Non" = FALSE), 
                   selected = TRUE),
      
      selectInput(inputId = "filter_color", 
                  label = "Filtrer par couleur :", 
                  choices = unique(diamonds$color), 
                  selected = "G"),
      
      sliderInput(inputId = "max_price", 
                  label = "Prix maximum :", 
                  min = 300, 
                  max = 20000, 
                  value = 3444, 
                  step = 100),
      
      # Bouton pour afficher une notification
      actionButton(inputId = "show_notification", 
                   label = "Afficher une notification")
    ),
    
    mainPanel(
      plotOutput(outputId = "scatter_plot"),
      DTOutput(outputId = "data_table")
    )
  )
)


server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(diamonds, 
           color == input$filter_color & 
             price <= input$max_price)
  })
  
  # Nuage de points
  output$scatter_plot <- renderPlot({
    p <- ggplot(filtered_data(), aes(x = carat, y = price))
    
    if (input$color_rose == TRUE) {
      p <- p + geom_point(color = "pink", alpha = 0.6)
    } else {
      p <- p + geom_point(alpha = 0.6)
    }
    
    p + labs(title = glue("prix: {input$max_price} & color: {input$filter_color}"),
             x = "Carat",
             y = "Prix") +
      theme_minimal() + 
      theme(
        plot.background = element_rect(fill = "gray98")
      )
  })
  
  # Tableau interactif avec DT
  output$data_table <- renderDT({
    datatable(filtered_data(), 
              options = list(pageLength = 10, 
                             scrollX = TRUE))
  })
  
  # Notification lorsque le bouton est cliqué
  observeEvent(input$show_notification, {
    showNotification(
      paste(glue("prix: {input$max_price}, 
            color: {input$filter_color}")),
      type = "message"
    )
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)

shinylive::export(
  appdir =".",
  destdir = "docs"
)
