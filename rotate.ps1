$path = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$log_list = Import-Csv $path/config.csv -Delimiter "~" -Header 'log_path', 'toKeep', 'log_name'

foreach($log in $log_list){
    
	#Check if the rotate folder exist. If not, it will create one for you.
	
	if(!(Test-Path "$($log.log_path)\rotate")){
		md "$($log.log_path)\rotate"
	}
	
    #Copy the log and erase the main one. If it's empty, it skips it.

    if(Get-Content "$($log.log_path)\$($log.log_name)"){
        cp "$($log.log_path)\$($log.log_name)" "$($log.log_path)\rotate\$(Get-Date -Format "MM-dd-yyyy")--$($log.log_name)"
		Clear-Content "$($log.log_path)\$($log.log_name)"
    }

    #Check if there is more than "toKeep". If yes, then delete the oldest one.

    $NbLogs = (Get-ChildItem "$($log.log_path)\rotate\" -Filter "*$($log.log_name)" | Measure-Object).Count;

    if($NbLogs -gt $log.toKeep){

        #removing the oldest log
        $FileDate = (Get-Date -Format g)
        $pathu = "$($log.log_path)\rotate\"
        Get-ChildItem -Path $pathu -Filter "*$($log.log_name)" | ForEach-Object {
            if ($_.LastWriteTime -lt $FileDate -and -not $_.PSIsContainer) {
                $FileDate = $_.LastWriteTime
                $OldFile = $_.FullName
            }
        }
        Remove-Item $OldFile
    }
}