# Nombre del directorio Log
$script_job = "MantenimientoDiarioDC1"
$wdir = "$env:USERPROFILE\Documents\$script_job"

# Retorna la hora y genera carpeta en arbol/ anio/ mes /dia / hora.

$path = "$wdir\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))\$((Get-Date).ToString('dd'))"
$hora = (Get-Date).ToString('HHmm')

# Crea la carpeta

New-Item -ItemType Directory -Path "$wdir\$((Get-Date).ToString('yyyy'))\$((Get-Date).ToString('MM'))\$((Get-Date).ToString('dd'))\" -Force

# Saludo

Write-Host ("`nHola " + $env:USERNAME + " :)`n")

# Registra los archivos en los log

Write-Host "Registrango archivos en Z:\TEMP"
Get-ChildItem -Path "z:\temp\" | Out-File $path\ztemp$hora.log -Verbose
Write-Host "Registrango archivos de Backup SYSMTI"
Get-ChildItem -Path "E:\sysmti_data" | Out-File $path\sysmti$hora.log -Verbose
Write-Host "Registrango archivos de Backup SYSMERC"
Get-ChildItem -Path "E:\sysmerc_data\" | Out-File $path\sysmerc$hora.log -Verbose
Write-Host "Registrango archivos de C:\TEMP"
Get-ChildItem -Path "c:\temp\" | Out-File $path\ctemp$hora.log -Verbose

# Respaldando Sistemas

./backup_sysmerc.ps1    
./backup_sysmti.ps1   

# Elimina los archivos anteriores a 1 día

Write-Host "Eliminando archivos en Z:\TEMP"
Get-ChildItem -Path "c:\sysmti\temp\" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-1))} | Remove-Item -Verbose -Recurse
Write-Host "Elimnando archivos de C:\TEMP"
Get-ChildItem -Path "c:\temp\" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-1))} | Remove-Item -Verbose -Recurse
Write-Host "Elimnando archivos de Backup SYSMTI"
Get-ChildItem -Path "E:\sysmti_data" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item -Verbose -Recurse
Write-Host "Elimnando archivos de Backup SYSMERC"
Get-ChildItem -Path "E:\sysmerc_data" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item -Verbose -Recurse
Write-Host "Listo!"

# Limpiar TrashBin de todos los usuarios de dominio

Get-ChildItem "C:\`$Recycle.bin\" | Remove-Item -Recurse -Force -WhatIf

Write-Host "FINALIZADO..."


