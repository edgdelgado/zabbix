09/09/2016
Ainda realizando testes, não criei o template no Zabbix ainda nem a forma de levar os dados para ele(talvez utilizar o Zabbix Sender).
Entretanto o arquivo snapshot.ps1 verifica e cria 2 arquivos.
  1. Arquivo formatado em json para o LLD do Zabbix.
  2. Arquivo tabulado com informações de tamanho e dias em que o snapshot existe.


snapshotslld.txt
```sh
{
	 "data":[

 { "{#VMSNAPSHOT}":"NOME_VM(Nome_SNAPSHOT)Nome_SnapShotPAI"}
,
 { "{#VMSNAPSHOT}":"NOME_VM2(Nome_SNAPSHOT2)"}

	 ]
}
``` 


snapshotsinfo.txt
```sh
#TYPE Selected.VMware.VimAutomation.ViCore.Impl.V1.VM.SnapshotImpl
"nmzbx","sizeb","tempo"
"NOME_VM(Nome_SNAPSHOT)Nome_SnapShotPAI","7487060601","14"
"NOME_VM2(Nome_SNAPSHOT2)","20559","43"
```
