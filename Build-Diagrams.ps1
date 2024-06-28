# Search for dot.exe in Program Files and Program Files (x86). Use special folder references to find the correct paths.
$dotPath = Get-ChildItem -Path "$env:ProgramFiles\Graphviz*\bin\dot.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
if (-not $dotPath) {
    $dotPath = Get-ChildItem -Path "$env:ProgramFiles(x86)\Graphviz*\bin\dot.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
}

if (-not $dotPath) {
    # Attempt to install Graphviz via winget
    winget install --id Graphviz.Graphviz
}

# Now search again
$dotPath = Get-ChildItem -Path "$env:ProgramFiles\Graphviz*\bin\dot.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
if (-not $dotPath) {
    $dotPath = Get-ChildItem -Path "$env:ProgramFiles(x86)\Graphviz*\bin\dot.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
}

if (-not $dotPath) {
    Write-Error "Graphviz not found. Please install Graphviz from https://graphviz.org/download/"
    exit 1
}

# Build the diagrams
$diagrams = Get-ChildItem -Filter *.dot -Recurse

foreach ($diagram in $diagrams) {
    & $dotPath -Tpng -O $diagram.FullName
}
