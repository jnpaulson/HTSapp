downloadNotInstalled<-function(x){
    for(i in x){
      if(!require(i,character.only=TRUE)){
        install.packages(i,repos="http://cran.r-project.org")
        library(i,character.only=TRUE)
      }
    }
}
downloadNotInstalledBioc<-function(x){
    for(i in x){
      if(!require(i,character.only=TRUE)){
        source("http://bioconductor.org/biocLite.R")
        biocLite(i,character.only=TRUE)
        library(i,character.only=TRUE)
      }
    }
}
requiredPackages = c("shiny","vegan")
downloadNotInstalled(requiredPackages)
requiredBiocPackages = c("metagenomeSeq","msd16s")
downloadNotInstalledBioc(requiredBiocPackages)

data(mouseData)
data(lungData)

shinyUI(fluidPage(
  titlePanel("Dynamically generated user interface components"),
  fluidRow(

    column(3, wellPanel(
      selectInput("input_type", "Input type",
        c("slider", "text", "numeric", "checkbox",
          "checkboxGroup", "radioButtons", "selectInput",
          "selectInput (multi)", "date", "daterange"
        )
      )
    )),

    column(3, wellPanel(
      # This outputs the dynamic UI component
      uiOutput("ui")
    )),

    column(3,
      tags$p("Input type:"),
      verbatimTextOutput("input_type_text"),
      tags$p("Dynamic input value:"),
      verbatimTextOutput("dynamic_value")
    )
  )
))
