# tabby2 

A friendly user tool for visualizing state level TB predictions and interventions. 

Online at https://ppmltools.org/tabby2

# Installation and Setup

Clone the project 

    git clone git@github.com:ppml/tabby2.git

Note that tabby2 makes use of Cario, a library in R which 
depends on having a few packages available.

On Debian based Linuxs this means having the following packages 
installed:

    sudo apt install libgtk2.0-dev libcairo2-dev xvfb xauth xfonts-base libxt-dev

Now we can go ahead and install the R package dependencies: 

    # move into our project on terminal:
    cd tabby2/
    git checkout beta/
    R

    # in R:
    devtools::install_deps("utilities/")
    devtools::install_deps("tabby1utilities/")

We will also need MITUS, the model of tuberculosis that Tabby2 renders the 
outcomes of. 

    # in terminal 
    cd .. # clone MITUS next to tabby2, or any other directory works fine too
    git clone git@github.com:PPML/MITUS.git
    cd MITUS/
    R

    # in R: 
    devtools::install("./", dependencies=TRUE)

Now we can run Tabby2

    # in terminal 
    cd ../
    cd tabby2/
    R

    # in R: 
    shiny::runApp()

