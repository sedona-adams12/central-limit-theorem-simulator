# Central Limit Theorem Simulator

An interactive R Shiny application that demonstrates the Central Limit Theorem through sampling simulations. Users can choose different population distributions, adjust sample sizes, and observe how the distribution of sample means changes.

**Live Demo:** [Central Limit Theorem Simulator](https://sedona123.shinyapps.io/dat301-clt-simulator/)

## Overview

This application allows users to explore the Central Limit Theorem by simulating repeated samples from different population distributions. It calculates the mean of each sample and displays the results in an interactive histogram.

The simulator demonstrates how the distribution of sample means becomes increasingly normal as the sample size increases, even when the original population distribution is not normal.

## Features

- **Population Distributions:** Choose between Normal, Uniform, and Exponential distributions.
- **Sample Size Control:** Adjust the number of observations per sample from 1 to 100.
- **Simulation Control:** Generate between 100 and 5,000 samples.
- **Interactive Histogram:** Visualize the distribution of simulated sample means using Plotly.
- **Theoretical Normal Curve:** Compare simulated results with the theoretical normal distribution.
- **Population Mean Reference:** View a dashed vertical line marking the population mean.
- **Summary Statistics:** Compare the population mean, simulated mean, theoretical standard error, and observed standard deviation.
- **CLT Explanation:** Explore an additional tab explaining the Central Limit Theorem.

## Technologies Used

- R
- Shiny
- ggplot2
- Plotly

## Running Locally

1. Clone the repository:

   ```bash
   git clone https://github.com/sedona-adams12/central-limit-theorem-simulator.git
   ```

2. Open the project directory:

   ```bash
   cd central-limit-theorem-simulator
   ```

3. Install the required R packages:

   ```r
   install.packages(c("shiny", "ggplot2", "plotly"))
   ```

4. Run the application:

   ```r
   shiny::runApp()
   ```

## Example Exploration

Select the Exponential distribution and begin with a sample size of 5. Run the simulation and observe the histogram of sample means. Then increase the sample size to 50 and run it again.

Although the original exponential population is skewed, the distribution of sample means should become more approximately normal as the sample size increases.

## Project Background

Developed as part of DAT 301: Applied Regression Analysis at Arizona State University.
