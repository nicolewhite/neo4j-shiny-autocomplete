source("neo4j.R")
library(shiny)

query = "
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.title = {title}
RETURN p.name AS actors
"

shinyServer(function(input, output) {
  output$actors <- renderTable({
    cypher(graph, query, title=input$title)
  })
})
