param(
    [string]$RHome = "C:\Program Files\R\R-4.3.3"
)

$ErrorActionPreference = "Stop"

if (Test-Path $RHome) {
    $env:R_HOME = $RHome
    $env:Path = "$RHome\bin\x64;$RHome\bin;$env:Path"
}

Write-Host "Rscript:"
Rscript --version

Write-Host ""
Write-Host "Required R packages:"
Rscript -e "pkgs <- c('dplyr','ggplot2','readr','tidyr','knitr','rmarkdown','brms','posterior','bayesplot','loo'); print(data.frame(package=pkgs, installed=sapply(pkgs, requireNamespace, quietly=TRUE)), row.names=FALSE)"

Write-Host ""
Write-Host "Quarto:"
quarto check
