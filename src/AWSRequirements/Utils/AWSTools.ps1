Function  Get-CurrentAWSAccountID {
    return or $env:AWS_ACCOUNT_ID `
        (Get-STSCallerIdentity -region us-east-1).Account
}