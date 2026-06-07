Import-Module ActiveDirectory

# CSV asukoht
$csvPath = "C:\Scripts\kasutajad.csv"

# Domeen ja baas-OU
$domain = "slillep.local"
$baseOU = "OU=Kasutajad,DC=slillep,DC=local"

# Impordi CSV
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {

# CSV veerud: Name, Username, Password, OU
$name = ($user.Name | ForEach-Object { $_.Trim() })
$username = ($user.Username | ForEach-Object { $_.Trim() })
$password = ($user.Password | ForEach-Object { $_.Trim() })
$ouName = ($user.OU | ForEach-Object { $_.Trim().Trim(",") }) # eemaldab nt "Töötajad,"

if ([string]::IsNullOrWhiteSpace($username) -or [string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($password)) {
Write-Host "Rida vahele: puudub Name/Username/Password (Username='$username')." -ForegroundColor Yellow
continue
}

# Spliti nimi: viimane sõna = perenimi, ülejäänu = eesnimi
$parts = $name -split '\s+' | Where-Object { $_ -ne "" }
if ($parts.Count -ge 2) {
$lastName = $parts[-1]
$firstName = ($parts[0..($parts.Count-2)] -join ' ')
} else {
# kui on ainult 1 sõna, pane see GivenName alla
$firstName = $name
$lastName = $name
}

# Siht-OU: kui OU veerg tühi, kasutab baseOU-d
$targetOU = $baseOU
if (-not [string]::IsNullOrWhiteSpace($ouName)) {
$targetOU = "OU=$ouName,$baseOU"

# Kui alam-OU ei eksisteeri, loo see
try {
Get-ADOrganizationalUnit -Identity $targetOU -ErrorAction Stop | Out-Null
} catch {
try {
New-ADOrganizationalUnit -Name $ouName -Path $baseOU -ProtectedFromAccidentalDeletion $true | Out-Null
Write-Host "Loodud OU: $targetOU" -ForegroundColor Cyan
} catch {
Write-Host "OU loomine ebaõnnestus ($targetOU). Kasutan baseOU: $baseOU" -ForegroundColor Yellow
$targetOU = $baseOU
}
}
}

# Kontrolli, kas kasutaja juba olemas
$existing = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue
if ($null -ne $existing) {
Write-Host "User '$username' already exists. Skipping." -ForegroundColor Yellow
continue
}

# Loo kasutaja
try {
New-ADUser `
-Name $name `
-DisplayName $name `
-GivenName $firstName `
-Surname $lastName `
-SamAccountName $username `
-UserPrincipalName "$username@$domain" `
-Path $targetOU `
-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
-Enabled $true `
-PasswordNeverExpires $true `
-CannotChangePassword $false

Write-Host "User '$username' created successfully in '$targetOU'." -ForegroundColor Green
} catch {
Write-Host "User '$username' creation FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
}
