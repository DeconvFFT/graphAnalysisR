library(tidyverse)

# sample edge and node data
edge_list <- tibble(from = c(1,2,2,3,4), to = c(2,3,4,2,1))
node_list <- tibble(id = 1:4)

print(edge_list)
print(node_list)

# graph using writer data
letters <- read_csv("data/correspondence_data.csv")

#' create a node list
#' Take distinct cities from both source and destination and join them

sources <- letters %>% 
  distinct(source) %>% 
  rename(label = source)

destinations <- letters %>% 
  distinct(destination) %>% 
  rename(label = destination)

# full join to include all unique locations from source and destination
nodes <- full_join(sources, destinations, by = "label")

#' generate unique ids which will be useful for graph
#' rowid_to_column() takes values from rowid and creates a column named id

nodes <- nodes %>% rowid_to_column("id")

#' generate edgelist
#' First step: calculate weight of edge between source and destination

per_route <- letters %>% 
  group_by(source, destination) %>% 
  summarise(weight = n()) %>% 
  ungroup()

per_route
