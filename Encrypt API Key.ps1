$key = Read-Host 'Enter encryption Key'
$key= $key.Split(',')
$Input = Read-Host "Input"
$Password = $Input | ConvertTo-SecureString -AsPlainText -Force
$Password_readable=$Password | ConvertFrom-SecureString -key $Key
$Password_readable
Set-Clipboard -Confirm -Value $Password_readable
Read-Host "Press Enter to exit"