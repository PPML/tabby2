# Tabby2 Versioning System

This document provides the specification for how the Tabby2 versioning system
should be used.

The purpose of the versioning system is to alert users of the Tabby2 web
application to changes to Tabby2 which they may want to take note of.

### Location of the Version Number

The authority on the Tabby2 version number is specified in the
`utilities/DESCRIPTION` file "Version:" line item. 

This is done so that Tabby2 can render its version number in many places from
one single source of authority.

### Changelog

The changelog providing brief descriptions of each version increment is 
stored in `utilities/inst/Rmd/changelog.Rmd`.

The changelog within Tabby2 should provide one-line descriptions of the release
and a link to more extensive release notes. 

### Version Format

The format of the Tabby2 version is given by three numbers separated by two
periods, e.g. "Tabby2 Version 2.0.0"

These version numbers are ordered in decreasing significance. 

Changes to the first of these version numbers should indicate a major change in
the scope of the project, such as changes in the funding source or
methodological approach.

Changes to the middle of these version numbers should indicate a significant
release, indicating the successful completion of another round of Scientific
Web Tool Clearance at the Centers for Disease Control and Prevention has been
performed for Tabby2. 

Changes to the last of these version numbers reflect smaller changes to the
contents of Tabby2 to which the user should be alerted, such as the expansion
and improvement of the underlying model, improvements to the user interface, or
changes which affect the numbers depicted in downloadable outcomes from the
application. 
