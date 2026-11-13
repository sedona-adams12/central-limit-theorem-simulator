# DAT 301 Lab 3: Central Limit Theorem Simulator
# Sedona Adams
library(shiny)
library(ggplot2)
library(plotly)

# Generate observations from the selected population distribution.
generate_population <- function(n, distribution) {
  if (distribution == "Normal") {
    rnorm(n, mean = 50, sd = 10)
  } else if (distribution == "Uniform") {
    runif(n, min = 0, max = 100)
  } else {
    rexp(n, rate = 1 / 20)
  }
}

ui <- fluidPage(
  titlePanel("Central Limit Theorem Simulator"),
  sidebarLayout(
    sidebarPanel(
      h4("Simulation settings"),
      selectInput(
        "distribution", "Population distribution",
        choices = c("Normal", "Uniform", "Exponential"),
        selected = "Exponential"
      ),
      sliderInput(
        "sample_size", "Sample size (n)",
        min = 1, max = 100, value = 5, step = 1
      ),
      sliderInput(
        "simulations", "Number of samples",
        min = 100, max = 5000, value = 1000, step = 100
      ),
      actionButton("run", "Run simulation", class = "btn-primary"),
      br(), br(),
      helpText("Change the settings and select Run simulation to generate a new set of sample means.")
    ),
    mainPanel(
      h3("Distribution of sample means"),
      plotlyOutput("mean_plot", height = "430px"),
      tabsetPanel(
        tabPanel("Summary", br(), tableOutput("summary_table")),
        tabPanel("About the CLT", br(),
          p("The Central Limit Theorem says that, under common conditions, the distribution of sample means becomes approximately normal as the sample size increases."),
          p("The population itself does not have to be normally distributed. This simulator uses normal, uniform, and right-skewed exponential populations to demonstrate the idea."),
          p("Try a small sample size first, then increase n and compare the shape of the sample-mean histogram.")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  simulation <- eventReactive(input$run, {
    means <- replicate(
      input$simulations,
      mean(generate_population(input$sample_size, input$distribution))
    )

    population_parameters <- switch(
      input$distribution,
      "Normal" = c(mean = 50, sd = 10),
      "Uniform" = c(mean = 50, sd = 100 / sqrt(12)),
      "Exponential" = c(mean = 20, sd = 20)
    )

    list(
      means = means,
      population_mean = unname(population_parameters["mean"]),
      population_sd = unname(population_parameters["sd"]),
      sample_size = input$sample_size,
      simulations = input$simulations,
      distribution = input$distribution
    )
  }, ignoreInit = FALSE)

  output$mean_plot <- renderPlotly({
    result <- simulation()
    means <- result$means

    plot_data <- data.frame(sample_mean = means)
    x_values <- seq(
      min(means) - sd(means),
      max(means) + sd(means),
      length.out = 300
    )
    normal_data <- data.frame(
      x = x_values,
      y = dnorm(
        x_values,
        mean = result$population_mean,
        sd = result$population_sd / sqrt(result$sample_size)
      )
    )

    p <- ggplot(plot_data, aes(x = sample_mean)) +
      geom_histogram(
        aes(y = after_stat(density)),
        bins = 30, fill = "#4C78A8", color = "white", alpha = 0.85
      ) +
      geom_line(
        data = normal_data,
        aes(x = x, y = y),
        color = "#E45756", linewidth = 1.2,
        inherit.aes = FALSE
      ) +
      geom_vline(
        xintercept = result$population_mean,
        linetype = "dashed", linewidth = 0.8
      ) +
      labs(
        title = paste("Sample means:", result$distribution, "population"),
        subtitle = paste(
          result$simulations, "samples | sample size n =",
          result$sample_size
        ),
        x = "Sample mean",
        y = "Density",
        caption = "Red curve: theoretical normal approximation. Dashed line: population mean."
      ) +
      theme_minimal(base_size = 13)

    ggplotly(p, tooltip = c("x", "y"))
  })

  output$summary_table <- renderTable({
    result <- simulation()
    data.frame(
      Measure = c(
        "Population distribution",
        "Number of samples",
        "Sample size",
        "Population mean",
        "Mean of simulated sample means",
        "Theoretical standard error",
        "Observed standard deviation of sample means"
      ),
      Value = c(
        result$distribution,
        result$simulations,
        result$sample_size,
        round(result$population_mean, 3),
        round(mean(result$means), 3),
        round(result$population_sd / sqrt(result$sample_size), 3),
        round(sd(result$means), 3)
      ),
      check.names = FALSE
    )
  }, striped = TRUE, bordered = TRUE, spacing = "m")
}

shinyApp(ui = ui, server = server)
