param(
    [string]$RHome = "C:\Program Files\R\R-4.3.3"
)

$ErrorActionPreference = "Stop"

if (Test-Path $RHome) {
    $env:R_HOME = $RHome
    $env:Path = "$RHome\bin\x64;$RHome\bin;$env:Path"
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$sassCache = Join-Path $env:LOCALAPPDATA "quarto\sass"
if (Test-Path $sassCache) {
    Remove-Item -LiteralPath $sassCache -Recurse -Force
}

quarto render "analysis\bayesian_workplace_stress.qmd" --to html
if ($LASTEXITCODE -ne 0) {
    throw "Quarto render failed with exit code $LASTEXITCODE."
}

New-Item -ItemType Directory -Force "docs" | Out-Null
Copy-Item "analysis\bayesian_workplace_stress.html" "docs\index.html" -Force

if (Test-Path "analysis\bayesian_workplace_stress_files") {
    if (Test-Path "docs\bayesian_workplace_stress_files") {
        Remove-Item "docs\bayesian_workplace_stress_files" -Recurse -Force
    }

    Copy-Item "analysis\bayesian_workplace_stress_files" "docs\bayesian_workplace_stress_files" -Recurse -Force
}

if (-not (Test-Path "docs\.nojekyll")) {
    Set-Content -Path "docs\.nojekyll" -Value "Static Quarto output for GitHub Pages." -Encoding UTF8
}

Write-Host "Report rendered and copied to docs/ for GitHub Pages."
