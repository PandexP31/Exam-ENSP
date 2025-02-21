#install.packages('usethis')
library(usethis)
usethis::use_git_config(
  scope ="user",
  user.name = "PandexP31",
  user.email = "mathieu.alves-de-paiva.etu@univ-lille.fr",
  init.defaultBranch='main'
)

install.packages("shiny")

install.packages("shinylive")

shinylive::export(
  appdir =".",
  destdir = "docs"
)