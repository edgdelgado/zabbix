#Adicionar Snapin do Powercli da VMware
Add-PSSnapin VMware.VimAutomation.Core

#Parâmetros de conexão com o vcenter  [FIXO]
$vmwserver  = *"
$vmwlogin   = "*"
$vmwpwd     = "*"
$vmwdc      = "*"

#Parâmetros de conexão com o vcenter [Argumentos externos]
#$vmwserver  = $args[0]
#$vmwlogin   = $args[1]
#$vmwpwd     = $args[2]
#$vmwdc     = $args[3]

#Conexão com o vcenter
connect-viserver -WarningAction 0 $vmwserver -user $vmwlogin -password $vmwpwd | out-null


## [INICIO] Função gerar arquivo em JSON para LLD DO ZABBIX cadastrar os snapshots existentes
function get-lldsnapshots
{

$llditems = get-vm -location $vmwdc | Get-Snapshot | Select-Object @{N="nmzbx"; E={""+$_.VM+"("+$_.Name+")"+$_.Children}}



Write-Host "{";
write-host "`t ""data"":[";
write-host

$temp = 1

foreach ($llditem in $llditems) {

 
 if ($temp -eq 0){
	Write-Host ",";
 } 
 else{
	$temp = 0;
 }
 $line = " { `"{#VMSNAPSHOT}`":`"" + $llditem.nmzbx + "`"}"

 	
		Write-Host -NoNewline $line
	}


write-host
write-host
write-host "`t ]";
write-host "}"



}
## [FIM] Função gerar arquivo em JSON para LLD DO ZABBIX


## [INICIO] Função coletar informações de tamanho em bytes e dias em que o snapshot foi criado
function get-snapshotinfos
{
get-vm -location $vmwdc | get-snapshot |
               #"NMBZBX" = "NomeVM(NomeSnapshot)NomeSNapshotPai" 
Select-Object  @{N="nmzbx"; E={""+$_.VM+"("+$_.Name+")"+$_.Children}},
               @{N="sizeb"; E={[math]::round(($_.SizeMB * 1024 * 1024)) }},
               @{N="tempo"; E={New-TimeSpan $_.Created $agora | select -ExpandProperty Days}}              




}
## [FIM] Função coletar informações de tamanho em bytes e dias em que o snapshot foi criado

# Exportar TXT do JSON para utilização do LLD.
get-lldsnapshots 6>&1 | out-file C:\zabbix\snapshotsinfo.txt

# Exportar TXT tabulado para coleta dos dados de tamanho e dias de snapshot.
get-snapshotinfos 6>&1 | Export-Csv C:\zabbix\snapshotslld.txt



