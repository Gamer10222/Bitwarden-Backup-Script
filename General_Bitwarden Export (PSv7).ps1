#$PSDefaultParameterValues = @{ '*:Encoding' = 'utf8bom' }
#API Key
$Account_1_ClientID='' 
$Account_1_ClientSecret_Secure='' #AES 256 encrypted

$Account_2_ClientID=''
$Account_2_ClientSecret_Secure='' #AES 256 encrypted

$Account_3_ClientID=''
$Account_3_ClientSecret_Secure='' #AES 256 encrypted


#Organisations IDs (bw list organizations)
$Org_1_ID=''
$Org_2_ID=''

#Define 7zip
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip file '$7zipPath' not found"
}
Set-Alias 7zip $7zipPath

#Variables
$DownloadFolder=(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path

#functions
	#login
	function BW-login
	{
		param
		(
			[Parameter(Mandatory)]
			[string]$API_ID,
			[Parameter(Mandatory)]
			[string]$API_Secret
		)

		$ENV:BW_CLIENTID=$API_ID
		$ENV:BW_CLIENTSECRET=$API_Secret
		bw logout
		bw login --apikey
		#Setting Session ID as env, so it can be usedSession ID als ENV zuweisen
		$ENV:BW_SESSION=(bw unlock --raw)
	}
	
	#Request
	function BW-export {
		$title    = 'Export'
		$question = 'What should be exportet'
		$choices  = '&0 Account_1 and Org1', '&1 Account_1', '&2 Org_1', '&3 Org_2 of Account_2', '&4 Account_3', '&All'

		$decision = $Host.UI.PromptForChoice($title, $question, $choices, 5)
		if ($decision -eq 0) {
			BW-login -API_ID $Account_1_ClientID -API_Secret $Account_1_ClientSecret
			Write-Host 'Account_1 and Org_1 will be exported'
			#Account_1
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).json" --format json
			#Org_1
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).json" --format json

		}elseif ($decision -eq 1) {
			BW-login -API_ID $Account_1_ClientID -API_Secret $Account_1_ClientSecret
			Write-Host 'Account_1 vault will be exported'
			#Account_1
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).json" --format json

		}elseif ($decision -eq 2) {
			BW-login -API_ID $Account_1_ClientID -API_Secret $Account_1_ClientSecret
			Write-Host 'Org_1 vault will be exported'
			#Org_1
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).json" --format json

		}elseif ($decision -eq 3) {
			BW-login -API_ID $Account_2_ClientID -API_Secret $Account_2_ClientSecret
			Write-Host 'Org_2 will be exported'
			#Org_2 of Account_2
			bw export --organizationid $Org_2_ID --output "$DownloadFolder\Delete\bitwarden_export_Account_2_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --organizationid $Org_2_ID --output "$DownloadFolder\Delete\bitwarden_export_Account_2_$(get-date -f yyyy-MM-dd-hhmm).json" --format json

		}elseif ($decision -eq 4) {
			BW-login -API_ID $Account_3_ClientID -API_Secret $Account_3_ClientSecret
			Write-Host 'Account_3 vault will be exported'
			#Account_3
			bw export  --output "$DownloadFolder\Delete\bitwarden_export_Account_3_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export  --output "$DownloadFolder\Delete\bitwarden_export_Account_3_$(get-date -f yyyy-MM-dd-hhmm).json" --format json
			
		}elseif ($decision -eq 5) {
			#Account_1 and Org_1
			Write-Host 'Enter Account_1 password'
			BW-login -API_ID $Account_1_ClientID -API_Secret $Account_1_ClientSecret
			Write-Host 'Account_1 and Org_1 will be exported'
			#Account_1
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --output "$DownloadFolder\Delete\bitwarden_export_$(get-date -f yyyy-MM-dd-hhmm).json" --format json
			#Org_1
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --organizationid $Org_1_ID --output "$DownloadFolder\Delete\bitwarden_export_Org_1_$(get-date -f yyyy-MM-dd-hhmm).json" --format json

			#Org_2 of Account_2
			Write-Host 'Enter Account_2 password'
			BW-login -API_ID $Account_2_ClientID -API_Secret $Account_2_ClientSecret
			Write-Host 'Account_2 Org_2 Vault will be exported'
			#Org_2 of Account_2
			bw export --organizationid $Org_2_ID --output "$DownloadFolder\Delete\bitwarden_export_Account_2_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export --organizationid $Org_2_ID --output "$DownloadFolder\Delete\bitwarden_export_Account_2_$(get-date -f yyyy-MM-dd-hhmm).json" --format json
			
			#Account_3
			Write-Host 'Enter Account_3 password'
			BW-login -API_ID $Account_3_ClientID -API_Secret $Account_3_ClientSecret
			Write-Host 'Account_3 vault will be exported'
			#Account_3
			bw export  --output "$DownloadFolder\Delete\bitwarden_export_Account_3_$(get-date -f yyyy-MM-dd-hhmm).csv" --format csv
			bw export  --output "$DownloadFolder\Delete\bitwarden_export_Account_3_$(get-date -f yyyy-MM-dd-hhmm).json" --format json
		}
		else {
			Write-Host 'cancelled'
		}
	}


#API Encryption Key request
$key = Read-Host 'Enter encryption key for API encryption'
$key= $key.Split(',')
$Account_1_ClientSecret=ConvertTo-SecureString $Account_1_ClientSecret_Secure -Key $key | ConvertFrom-SecureString -AsPlainText #Decrypted AES Key
$Account_2_ClientSecret=ConvertTo-SecureString $Account_2_ClientSecret_Secure -Key $key | ConvertFrom-SecureString -AsPlainText #Decrypted AES Key
$Account_3_ClientSecret=ConvertTo-SecureString $Account_3_ClientSecret_Secure -Key $key | ConvertFrom-SecureString -AsPlainText #Decrypted AES Key
BW-export


#Again?
do{
	$title    = 'Again?'
	$question = 'Should something else be exported?'
	$choices  = '&Yes', '&No'

	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 1) {
		BW-export
	} else {
		$repeat=$false
	}
}until($repeat -eq $false)


#Logout
bw lock
bw logout


#GPG Encrypt exported files?
$title    = 'GPG Encryption'
$question = 'Should the files get GPG encrypted'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
if ($decision -eq 0) {
	$Files=Get-ChildItem "$DownloadFolder\Delete\*" -Include *.csv, *.json #Puts all csv and json file into a variable
	cd "$DownloadFolder\Delete"
	ForEach ($File in $Files)
	{
		gpg --sign --encrypt --recipient RECIPIENT $File.name #Encrypts and signs every file
	} 
	#Creating archive
	$Files_GPG=Get-ChildItem "$DownloadFolder\Delete\*" -Include *.gpg
	7zip a -mx=9 "$DownloadFolder\Delete\$(get-date -f yyyy-MM-dd-hhmm)_bitwarden_export.7z" $Files_GPG
} else {
}

