# Run:
# $ Rscript install_R_packages.r
print("remember to:")
print("$ sudo pacman -Rdd r")
print("$ sudo sudo rm -r /usr/lib/R")
print("$ sudo pacman -S r")

chooseCRANmirror(ind = 1) # select first CRAN mirror

tryInstall <- function(packageName, loadPackage = FALSE, biocInstaller = FALSE) {
  print(paste0("Trying to install: ", packageName))
  if(!requireNamespace(packageName, quietly = TRUE)) { # if package can not be loaded
    if(biocInstaller == TRUE) {
      BiocManager::install(packageName)
    } else {
      install.packages(packageName)
    }
  } else { # if package can be loaded
    print("- Already installed.")
  }
  if(loadPackage == TRUE) { # if the user wants to load the package
    library(packageName, character.only = TRUE)
  }
}

tryInstall("BiocManager", loadPackage = TRUE)
tryInstall("tidyverse", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("dada2", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("edgeR", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("Biostrings", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("reticulate", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("readxl", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("forcats", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("gtools", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("taxize", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("rvest", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("cowplot", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("kableExtra", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("wesanderson", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("vegan", loadPackage = FALSE, biocInstaller = TRUE)
tryInstall("writexl", loadPackage = FALSE, biocInstaller = TRUE)
