# CPJ: Journalists killed from january 1992 to May 2017

Data from the **Committee to Protect Journalists** <https://cpj.org/>


Shiny App: https://songeo.shinyapps.io/killedjournalists_app/


---

This project uses `ProjectTemplate`. 

ProjectTemplate is an R package that helps you organize your statistical
analysis projects. Since you're reading this file, we'll assume that you've
already called `create.project()` to set up this project and all of its
contents.

To load your new project, you'll first need to `setwd()` into the directory
where this README file is located. Then you need to run the following two
lines of R code:

	library('ProjectTemplate')
	load.project()

After you enter the second line of code, you'll see a series of automated
messages as ProjectTemplate goes about doing its work. This work involves:
* Reading in the global configuration file contained in `config`.
* Loading any R packages you listed in he configuration file.
* Reading in any datasets stored in `data` or `cache`.
* Preprocessing your data using the files in the `munge` directory.

Once that's done, you can execute any code you'd like. For every analysis
you create, we'd recommend putting a separate file in the `src` directory.
If the files start with the two lines mentioned above:

	library('ProjectTemplate')
	load.project()

You'll have access to all of your data, already fully preprocessed, and
all of the libraries you want to use.

For more details about ProjectTemplate, see http://projecttemplate.net
