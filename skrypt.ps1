$timestamp = (Get-Date -Format "yyyyMMddHHmmss")
$path = "E:\bazydanychskrypt1011\PROCESSED"


if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path
}

function log {
    param ($message)
    $log = "$(Get-Date -Format 'yyyyMMddHHmmss') $message"
    Write-Host $log
    Add-Content -Path "$path\script_${timestamp}.log" -Value $log
}

function error {
    param ($message)
    Log "Error: $message"
    Exit 1
}

try {
    log "pobieranie"
    Invoke-WebRequest -Uri "https://home.agh.edu.pl/~wsarlej/Customers_Nov2024.zip" -OutFile "$path\Customers_Nov2024.zip"
    Invoke-WebRequest -Uri "https://home.agh.edu.pl/~wsarlej/Customers_old.csv" -OutFile "$path\Customers_old.csv"
} catch {
    error "blad pobierania"
}

try {
    log "rozpakowywanie"
    Expand-Archive -Path "$path\Customers_Nov2024.zip" -DestinationPath "$path" -Force
} catch {
    error "blad rozpakowywania"
}

try {
    log "walidacja"
    $file = Import-Csv -Path "$path\Customers_Nov2024.csv" -Delimiter ","
    $fileold = Import-Csv -Path "$path\Customers_old.csv" -Delimiter ","

    $validate = $file | Where-Object { $_.first_name -ne $null -and $_.last_name -ne $null -and $_.email -ne $null } | Where-Object { $_.email -ne "" }
    $final = $validate | Where-Object {
        -not ($fileold | Where-Object { $_.first_name -eq $validate.first_name -and $_.last_name -eq $validate.last_name -and $_.email -eq $validate.email -and $_.lat -eq $validate.lat -and $_.long -eq $validate.long })
    }
    if ($final.Count -eq 0) {
        error "blad walidacji"
    } else {
        $final | Export-Csv -Path "$path\Customers_final.csv" -NoTypeInformation -Delimiter ","
    }
} catch {
    error "blad walidacji"
}


try {
    log "tworzenie tabeli"
    E:\PostgreSQL\bin\psql.exe -h "localhost" -U "postgres" -d "skrypt" -c "CREATE TABLE IF NOT EXISTS CUSTOMERS_416913 (first_name varchar(50),last_name varchar(50),email varchar(50),lat varchar(50),long varchar(50),geoloc GEOGRAPHY(POINT, 4326));"

} catch {
    error "blad tworzenia tabeli"
}

try {
    log "dodawanie danych"
    E:\PostgreSQL\bin\psql.exe -h "localhost" -U "postgres" -d "skrypt" -c "COPY CUSTOMERS_416913(first_name, last_name, email, lat, long) FROM '$path\Customers_final.csv' WITH DELIMITER ',' CSV"
    E:\PostgreSQL\bin\psql.exe -h "localhost" -U "postgres" -d "skrypt" -c "UPDATE CUSTOMERS_416913 SET geoloc = ST_SetSRID(ST_MakePoint(long::numeric, lat::numeric), 4326);"
} catch {
    error "blad dodawania danych"
}

try {
    log "przenoszenie pliku"
    Move-Item -Path "$path\Customers_final.csv" -Destination "$path/${timestamp}_Customers_final.csv"
} catch {
    error "blad w przenoszeniu"
}
