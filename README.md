# Trove_workshop
R SHiny interface to Trove API with csv data download

The Shiny webapp allows the interface with the Trove API.
- An API key needs to be supplied for this to work.
- the user can (currently) select one zone to search
- selection of brief or full records possible
- The app displays the search results in a table
- search results can be viewed by clicking on links in the troveUrl column
- Download Data will open a dialog box to download the displayd table as a csv file

Work To Do:
- implement iteration of the search until all results are collated (i.e. there might be 200 records but the API only allows retrieval of 100 at a time)
- implement input selection for years
