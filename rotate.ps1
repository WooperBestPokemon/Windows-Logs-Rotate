$path = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$log_list = Import-Csv $path/config.csv -Delimiter ";" -Header 'log_path', 'toKeep', 'log_name'

"-----STARTED $(get-date)------" | Out-File -FilePath $path\logs\Debug.log -Append
"" | Out-File -FilePath $path\logs\Debug.log -Append
foreach($log in $log_list){
    "~~ Starting operation on $($log.log_path)\$($log.log_name)" | Out-File -FilePath $path\logs\Debug.log -Append
    #Copy the log and erase the main one. If it's empty, it skips it.
    if(!(Test-Path "$($log.log_path)\rotate")){
		"Directory does not exist.. Creating it." | Out-File -FilePath $path\logs\Debug.log -Append
        md "$($log.log_path)\rotate"
    }

    if(Get-Content "$($log.log_path)\$($log.log_name)"){
		"Moving and clearing content..." | Out-File -FilePath $path\logs\Debug.log -Append
        cp "$($log.log_path)\$($log.log_name)" "$($log.log_path)\rotate\$(Get-Date -Format "MM-dd-yyyy")--$($log.log_name)"
		Clear-Content "$($log.log_path)\$($log.log_name)"
    }
	else{
		"Log is empty, ignoring.." | Out-File -FilePath $path\logs\Debug.log -Append
	}

    #Check if there is more than "toKeep". If yes, then delete the oldest one.

    $NbLogs = (Get-ChildItem "$($log.log_path)\rotate\" -Filter "*$($log.log_name)" | Measure-Object).Count;

    if($NbLogs -gt $log.toKeep){
		"The number of log to exceed the limit, deleting the oldest file." | Out-File -FilePath $path\logs\Debug.log -Append
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
"All the operations are now finished." | Out-File -FilePath $path\logs\Debug.log -Append
"" | Out-File -FilePath $path\logs\Debug.log -Append