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


choiceValues = colnames(pData(msd16s))
names(choiceValues) = choiceValues

choiceValues1 = colnames(pData(lungData))
names(choiceValues1) = choiceValues1

choiceValues2 = colnames(pData(mouseData))
names(choiceValues2) = choiceValues2

shinyServer(function(input, output) {

  output$ui <- renderUI({
    if (is.null(input$input_type))
      return()

    # Depending on input$input_type, we'll generate a different
    # UI component and send it to the client.
    switch(input$input_type,
      "slider" = sliderInput("dynamic", "Dynamic",
                             min = 1, max = 20, value = 10),
      "text" = textInput("dynamic", "Dynamic",
                         value = "starting value"),
      "numeric" =  numericInput("dynamic", "Dynamic",
                                value = 12),
      "checkbox" = checkboxInput("dynamic", "Dynamic",
                                 value = TRUE),
      "checkboxGroup" = checkboxGroupInput("dynamic", "Phenotype",
        choices = choiceValues,
        selected = choiceValues[1]
      ),
      "checkboxGroup1" = checkboxGroupInput("dynamic", "Phenotype",
        choices = choiceValues1,
        selected = choiceValues1[1]
      ),
      "checkboxGroup2" = checkboxGroupInput("dynamic", "Phenotype",
        choices = choiceValues2,
        selected = choiceValues2[1]
      ),            
      "radioButtons" = radioButtons("dynamic", "Dynamic",
        choices = c("Option 1" = "option1",
                    "Option 2" = "option2"),
        selected = "option2"
      ),
      "selectInput" = selectInput("dynamic", "Dynamic",
        choices = c("Option 1" = "option1",
                    "Option 2" = "option2"),
        selected = "option2"
      ),
      "selectInput (multi)" = selectInput("dynamic", "Dynamic",
        choices = c("Option 1" = "option1",
                    "Option 2" = "option2"),
        selected = c("option1", "option2"),
        multiple = TRUE
      ),
      "date" = dateInput("dynamic", "Dynamic"),
      "daterange" = dateRangeInput("dynamic", "Dynamic")
    )
  })

  output$input_type_text <- renderText({
    input$input_type
  })

  output$dynamic_value <- renderPrint({
    str(input$dynamic)
  })
  
  output$unique_levels <- renderPrint({
    if(input$input_type == "checkboxGroup") {
      out = sapply(input$dynamic,function(i){
              as.character(unique(pData(msd16s)[,i]))
      })
    }
    if(input$input_type == "checkboxGroup1") {
      out = sapply(input$dynamic,function(i){
              as.character(unique(pData(lungData)[,i]))
      })
    }
    if(input$input_type == "checkboxGroup2") {
      out = sapply(input$dynamic,function(i){
              as.character(unique(pData(mouseData)[,i]))
      })
    }        
    out
  })
})

