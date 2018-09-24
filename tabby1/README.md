# tabby

An Exploration of TB Transmission in the US

## the `utilities` folder

The `utilities/` folder is a package of functions used to build the tabby application. Additionally the data produced by the model is contained in this package in the `inst/` folder, see [`utilities/inst/`](https://github.com/PPML/tabby/tree/master/utilities/inst).

The functions in this package are called in the `server.R` and `ui.R` files. 

## the `compliance` folder

This is probably outdated, but stored notes regarding compliance.

## the `dependencies.R` file

This file is a shinyapps workaround. Shinyapps searches files for references to packages either by identifying calls to `library()` or `require()` or calls to `::`. This file ensures that shinyapps is aware of and will install the packages necessary to run the tabby application.


