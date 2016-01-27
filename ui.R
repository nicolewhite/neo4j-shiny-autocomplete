source("neo4j.R")
library(shiny)

movies = cypher(graph, "MATCH (m:Movie) RETURN m.title AS movie")$movie

shinyUI(bootstrapPage(
    singleton(
      tags$head(tags$script(src="typeahead.js"))
    ),
    
    tags$script(paste0("
      $(document).ready(function() {
        var substringMatcher = function(strs) {
          return function findMatches(q, cb) {
            var matches, substringRegex;
            
            // an array that will be populated with substring matches
            matches = [];
            
            // regex used to determine if a string contains the substring `q`
            substrRegex = new RegExp(q, 'i');
            
            // iterate through the pool of strings and for any string that
            // contains the substring `q`, add it to the `matches` array
            $.each(strs, function(i, str) {
              if (substrRegex.test(str)) {
                matches.push(str);
              }
            });
          
            cb(matches);
          };
        };
        
        var movies = ", RJSONIO::toJSON(movies), ";
        
        $('#the-basics .typeahead').typeahead({
          hint: true,
          highlight: true,
          minLength: 1
        },
        {
          name: 'movies',
          source: substringMatcher(movies)
        });
      })

      var title = $('.typeahead').typeahead('val');
      Shiny.onInputChange('title', title);
    ")
    ),
    
    titlePanel("Movies and Actors"),
    tags$div(id="the-basics", tags$input(class="typeahead", type="text", placeholder="The Matrix")),
    mainPanel(
      tableOutput("actors")
    )
  )
)
