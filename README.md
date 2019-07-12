# AWSRequirements

## Why
Generally in AWS many resources come together to what i would consider a 
component of an overall software system. This can mean the setting up of
many event feeders such as sns topics, cloudwatch events, and sqs queues
to support the processing engine such as lambda or a fargate container.

## Vision
Code can be declared and then parsed to find the overall needs of the
component. _An example might be a package.json for a serverless deployment._
This can be parsed and compiled into a requirements document and deployed into
a live environment.

For more information for more information on requirements please visit the
microsoft documentation [here](https://github.com/microsoft/requirements).


