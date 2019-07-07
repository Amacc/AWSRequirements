
Function New-AWSSNSRequirement{
    [cmdletbinding()] param(
        $Name,
        $Parameters
    )
    process{
        Write-Verbose $Name
        Write-Verbose ($Parameters | Out-String)
        $arn = @(
            "arn:aws:sns",
            (or $Parameters.Region $ENV:AWS_REGION (Get-DefaultAWSRegion)),
            (or $Parameters.AccountId (Get-CurrentAWSAccountID)),
            $Name
        ) -join ':'
        return @{
            Name     = $arn
            Describe = "$arn Exists"
        }
    }
}

Export-ModuleMember -Function New-AWSSNSRequirement