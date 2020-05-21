<#
    .SYNOPSIS     

    .DESCRIPTION
       
    .PARAMETER Path

    .PARAMETER SearchString -Optional

    .PARAMETER csvFile
#> 
 
param(
    [Parameter()][string]$Path = 'D:\Repos\',
    [Parameter(Mandatory=$false )][string] $SearchString, 
    [Parameter()][string]$csvFile = "$((Get-Date).ToString("yyyyMMdd_HHmmss"))_CertificatesStatsExport.csv"
)


Function GetSearchResult([string]$CertName)
{
    $obj = Get-ChildItem -Path $Path -Include *.xml, *.config -Recurse |`
    Select-String -Pattern $CertName| Select-Object -Property Pattern, Line, FileName, Path, LineNumber 
    
    $obj | Export-Csv $tmpFilePath -Append -NoTypeInformation -Force
    Write-Output ("Searching " + $CertName +" in files..")
    Write-Output $obj | Format-Table
}

Function ReplaceContent([string]$OldValue, [string]$NewValue)
{
  
   Get-ChildItem -Path $Path -Include *.cs, *.json, *.xml, .config -Recurse | ForEach {
     (Get-Content $_ | ForEach  { $_ -replace $OldValue , $NewValue }) |
     Set-Content $_
   }  
   
   <#
        #$exclude = @("*log*", "*bak*")
        $files = Get-ChildItem -Path $Path -Recurse

        foreach ($file in $files){

        $find = $OldValue
        $replace = $NewValue
        $content = Get-Content $($file.FullName) -Raw
        #write replaced content back to the file
        $content -replace $find,$replace | Out-File $($file.FullName) 
        }  
   #>
}



$tmpFilePath = join-path $Path $csvFile

#If an user does not provide a SearchString 
if([String]::IsNullOrWhiteSpace($SearchString) )
{

    #Get certiifcate 
    GetSearchResult("certiifcate");

    # Get thumbprint 
    GetSearchResult("thumbprint");

    # Get clientId 
    GetSearchResult("clientId");

     # Get SecretId 
    GetSearchResult("SecretId");

      # Get SerialNumber 
    GetSearchResult("SerialNumber");

      # Get X509 
    GetSearchResult("X509");

    Write-Output ("Output File Path: " + $tmpFilePath)
}
else
{
    GetSearchResult($SearchString);
}


