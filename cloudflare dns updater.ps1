$authemail = "" #the email you login with on cloudflare
$token = "" #your api token
$zoneId = "" #your zone ID
$recordNames = "" -split "," #You can add multiple entires (a records) separate with comma. IE: mysite.com,test.mysite.com

$IP = Invoke-RestMethod https://api.ipify.org -Method Get
$baseurl = "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records"
if($IP -ne ""){
    $headers = @{
        'X-Auth-Key' = $token
        'X-Auth-Email' = $authemail
    } #auth headers
    foreach($record in $recordNames){ #loop through records
        $target = "$($baseurl)?type=a&name=$record"
        $dnsrecord = Invoke-RestMethod -Uri $target -Method Get -Headers $headers

        if($dnsrecord.result.count -gt 0){ #check if theres an entry found
            $recordid = $dnsrecord.result.id
            Write-Host "ID of $($record): $($recordid)"
            if($dnsrecord.result[0].content -ne $IP){ #check if the IP is the same or not, we do not want to update if it's already the same (waste of requests)
                $data = @{
                    content = $IP
                    type = "A"
                    name = "$record"
                    ttl = $dnsrecord.result[0].ttl
                    proxied = $dnsrecord.result[0].proxied
                }
                $body = $data | ConvertTo-Json
                $updateurl = "$($baseurl)/$recordid"
                $result = Invoke-RestMethod -Uri $updateurl -Method Put -Headers $headers -Body $body
                Write-Output "Record $($record) has been updated to the IP: $($IP)"
            }
        }
    }
}