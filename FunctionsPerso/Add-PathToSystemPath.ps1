function Add-Path($Path) {
    $Path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $Path
    [Environment]::SetEnvironmentVariable( "Path", $Path, "Machine" )
}
$Programme_path = "YOURPATH"
$pathContent = [Environment]::GetEnvironmentVariable('path', 'Machine')
if ($pathContent -ne $null)
{
  # "Exist in the system!"
  if (!($pathContent -split ';'  -contains  $Programme_path))
  {
    
    Write-Host "$Programme_path does not exist"
    add-path $Programme_path
    
  }
  else
  {
    # My path Exists
    Write-Host "$Programme_path exists"

  }
}