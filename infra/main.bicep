// Entry point for the project's Azure infrastructure.
// Add resource declarations or module references here as the deployment grows.

targetScope = 'resourceGroup'

@description('Short name used as a prefix for all resources in this deployment.')
param projectName string = 'private-credit-agent-demo'

@description('Azure region for resources.')
param location string = resourceGroup().location

output projectName string = projectName
output location string = location
