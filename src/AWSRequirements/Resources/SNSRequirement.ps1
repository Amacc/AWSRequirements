<#
    .Description
        Interface::
            Parameters = @{
                Name   = "ProdTopic"
                Attributes = @{
                    Policy = '{"Version":"2008-10-17","Id":"__default_policy_ID","Statement":[{"Sid":"__default_statement_ID","Effect":"Allow","Principal":{"AWS":"*"},"Action":["SNS:GetTopicAttributes","SNS:SetTopicAttributes","SNS:AddPermission","SNS:RemovePermission","SNS:DeleteTopic","SNS:Subscribe","SNS:ListSubscriptionsByTopic","SNS:Publish","SNS:Receive"],"Resource":"arn:aws:sns:us-east-1:078756283323:dynamodb","Condition":{"StringEquals":{"AWS:SourceOwner":"078756283323"}}}]}'
                }
                Region = "us-east-1"
            }

    .EXAMPLE
        [pscustomobject]@{
            Type        = "SNS"
            Parameters  = @{
                Name    = "ProdTopic"
                Attributes = @{
                    Policy = '{"Version":"2008-10-17","Id":"__default_policy_ID","Statement":[{"Sid":"__default_statement_ID","Effect":"Allow","Principal":{"AWS":"*"},"Action":["SNS:GetTopicAttributes","SNS:SetTopicAttributes","SNS:AddPermission","SNS:RemovePermission","SNS:DeleteTopic","SNS:Subscribe","SNS:ListSubscriptionsByTopic","SNS:Publish","SNS:Receive"],"Resource":"arn:aws:sns:us-east-1:078756283323:dynamodb","Condition":{"StringEquals":{"AWS:SourceOwner":"078756283323"}}}]}'
                }
                Region  = "us-east-1"
            }
        } |
            New-AWSResourcesRequirement |
            InvokeRequirement |
            Format-Checklist
#>

Function Test-AWSSNSRequirement {
    [cmdletbinding()]
    param($Parameters)
    return {
        $retrievedAttributes = Get-SNSTopicAttribute -TopicArn $Parameters.Arn `
            -Region $Parameters.Region -ErrorAction SilentlyContinue

        if(-not $retrievedAttributes){ return $False}

        return -not [boolean]( # Return True if all attrs provided are in state
            Compare-Hashtable $Parameters.Attributes $retrievedAttributes |
                Where-Object{ $_.side -ne "=>"}
        )

    }.GetNewClosure()
    return $False
}

Function Set-AWSSNSRequirement {
    [cmdletbinding()]
    param($Parameters)
    return {
        $retrievedAttributes = Get-SNSTopicAttribute -TopicArn $Parameters.Arn `
            -Region $Parameters.Region -ErrorAction SilentlyContinue
        if(-not $retrievedAttributes){
            return New-SNSTopic -Name $Parameters.Name `
                -Attribute $Parameters.Attributes -Region $Parameters.Region
        }
        $Parameters.Attributes.GetEnumerator() |
            ForEach-Object {
                Set-SNSTopicAttribute -TopicArn $Parameters.Arn `
                    -AttributeName $_.Key -AttributeValue $_.Value `
                    -Region $Parameters.Region
            }
    }.GetNewClosure()
}

Function New-AWSSNSRequirement{
    [cmdletbinding()] param(
        $Parameters
    )
    process{
        if( -not $Parameters.Region){
            $Parameters.Region = (or $ENV:AWS_REGION (Get-DefaultAWSRegion))
        }
        $Parameters.Arn = @(
            "arn:aws:sns", $Parameters.Region
            (or $Parameters.AccountId (Get-CurrentAWSAccountID)),
            $Parameters.Name
        ) -join ':'

        return @{
            Name        = $Parameters.Arn
            Describe    = "$($Parameters.Arn) Exists"
            Test        = (Test-AWSSNSRequirement $Parameters)
            Set         = (Set-AWSSNSRequirement $Parameters)
        }
    }
}

Export-ModuleMember -Function New-AWSSNSRequirement, Test-AWSSNSRequirement