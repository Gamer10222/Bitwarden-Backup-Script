$key = New-Object Byte[] 32   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$ofs = ', '
$string_key=[string]$key | Set-Clipboard -Confirm
$key
read-host “Press ENTER to continue...”