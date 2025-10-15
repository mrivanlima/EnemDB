# import_zipcode.ps1
# End-to-end: SQL Server -> TSV (UTF-8, no BOM) -> Postgres \copy

$ErrorActionPreference = 'Stop'

# ========================== CONFIG ==========================
# --- SQL Server (source) ---
$SqlServer = "SQL8005.site4now.net"
$SqlDb     = "db_a9b211_intelipharma"
$SqlSchema = "Imp"
$SqlTable  = "CepInfo2"
$SqlUser   = "db_a9b211_intelipharma_admin"
$SqlPass   = "de102162"
$SqlServerTcp = "tcp:$SqlServer,1433"   # force TCP/1433

# --- Postgres (target) ---
$PgHost   = "localhost"
$PgPort   = 5432
$PgDb     = "enem"
$PgUser   = "postgres"
$PgPass   = "postgres"
$PgSchema = "imp"
$PgTable  = "zipcode_info"

# --- Files ---
$File = Join-Path $env:TEMP "cepinfo2_full.tsv"
# ============================================================

Write-Host "== Step 0: Quick TCP check to $SqlServer:1433 =="
try {
  $tcp = Test-NetConnection $SqlServer -Port 1433
  if (-not $tcp.TcpTestSucceeded) { throw "Port 1433 unreachable." }
  Write-Host "  ✓ 1433 reachable"
} catch {
  Write-Warning $_
}

Write-Host "== Step 1: Export from SQL Server to TSV (UTF-8) =="

# Sanitize CR/LF in text fields to keep one row per record, fixed column order
$sql = @"
SELECT
  [CepId],
  REPLACE(REPLACE([CidadeNome], CHAR(13), ' '), CHAR(10), ' ') AS [CidadeNome],
  [ibge],
  [ddd],
  [estadoSigla],
  [Altitude],
  [longitude],
  REPLACE(REPLACE([bairro],      CHAR(13), ' '), CHAR(10), ' ') AS [bairro],
  REPLACE(REPLACE([complemento], CHAR(13), ' '), CHAR(10), ' ') AS [complemento],
  [cep],
  REPLACE(REPLACE([logradouro],  CHAR(13), ' '), CHAR(10), ' ') AS [logradouro],
  [latitude]
FROM [$SqlDb].[$SqlSchema].[$SqlTable];
"@

# Use sqlcmd to write DIRECTLY to file with UTF-8; avoids PowerShell re-encoding
$sqlcmdArgs = @(
  "-S", $SqlServerTcp,
  "-d", $SqlDb,
  "-U", $SqlUser, "-P", $SqlPass,
  "-l", "45",
  "-Q", $sql,
  "-W",         # trim trailing spaces
  "-h", "-1",   # no headers
  "-s", "`t",   # TAB delimiter
  "-f", "65001",# UTF-8 codepage
  "-o", $File   # write straight to file (UTF-8)
)
Write-Host "  Running sqlcmd export..."
& sqlcmd @sqlcmdArgs
if ($LASTEXITCODE -ne 0) { throw "sqlcmd export failed." }

# Step 1b: Remove blank lines and ensure exactly 12 TAB-separated fields per line
Write-Host "  Cleaning file (remove blank/short lines)..."
$lines   = Get-Content -LiteralPath $File
$cleaned = foreach ($ln in $lines) {
  if ($ln -eq $null) { continue }
  $trim = $ln.Trim()
  if ($trim -eq "") { continue }
  $parts = $ln.Split("`t")
  if ($parts.Count -eq 12) { $ln }
}
# Save back as UTF-8 without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($File, $cleaned, $utf8NoBom)

# Show a tiny preview
Write-Host "  Preview first 3 lines:"
Get-Content -LiteralPath $File -TotalCount 3 | ForEach-Object { "    $_" }

Write-Host "== Step 2: Import into Postgres (UTF-8) =="
$env:PGPASSWORD = $PgPass

# Ensure schema exists; set client_encoding explicitly to UTF8
psql -h $PgHost -p $PgPort -U $PgUser -d $PgDb -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS $PgSchema;"
psql -h $PgHost -p $PgPort -U $PgUser -d $PgDb -v ON_ERROR_STOP=1 -c "SET client_encoding = 'UTF8';"

# OPTIONAL: truncate for clean reload
# psql -h $PgHost -p $PgPort -U $PgUser -d $PgDb -v ON_ERROR_STOP=1 -c "TRUNCATE TABLE $PgSchema.$PgTable;"

# Windows path -> forward slashes for psql
$PgFile = ($File -replace '\\','/')

# COPY via \copy (client-side). Column order fixed.
$copyCmd = @"
\copy $PgSchema.$PgTable (
  cepid, cidadenome, ibge, ddd, estadosigla, altitude, longitude,
  bairro, complemento, cep, logradouro, latitude
)
FROM '$PgFile'
WITH (FORMAT csv, DELIMITER E'\t', NULL '', HEADER false, QUOTE E'\b');
"@

Write-Host "  Loading data with \copy ..."
psql -h $PgHost -p $PgPort -U $PgUser -d $PgDb -v ON_ERROR_STOP=1 -c $copyCmd

# Show row count
psql -h $PgHost -p $PgPort -U $PgUser -d $PgDb -c "SELECT COUNT(*) AS rows_loaded FROM $PgSchema.$PgTable;"

Write-Host "== All done =="
