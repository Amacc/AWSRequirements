
$resourcesRequirementMapping = @{
    SNS = ${Function:New-AWSSNSRequirement}
    SQS = ${Function:New-AWSSQSRequirement}
}
Function New-AWSResourcesRequirement{
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)] $Type,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)] $Parameters
    )
    process{
        if($resourcesRequirementMapping.Keys -notcontains $Type){
            throw "Resource Not Found"
        }
        Write-Verbose $_
        .$resourcesRequirementMapping.$Type -Parameters $Parameters
    }
}
Export-ModuleMember -Function New-AWSResourcesRequirement