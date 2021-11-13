# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{
     param
     (
         [Parameter(Mandatory=$True)]
         [String]$RegistrationUrl,
 
         [Parameter(Mandatory=$True)]
         [String]$RegistrationKey,
 
         [Parameter(Mandatory=$True)]
         [String[]]$ComputerName,
 
         [Int]$RefreshFrequencyMins = 30,
 
         [Int]$ConfigurationModeFrequencyMins = 15,
 
         [String]$ConfigurationMode = 'ApplyAndMonitor',
 
         [String]$NodeConfigurationName,
 
         [Boolean]$RebootNodeIfNeeded= $False,
 
         [String]$ActionAfterReboot = 'ContinueConfiguration',
 
         [Boolean]$AllowModuleOverwrite = $False,
 
         [Boolean]$ReportOnly
     )
 
     if(!$NodeConfigurationName -or $NodeConfigurationName -eq '')
     {
         $ConfigurationNames = $null
     }
     else
     {
         $ConfigurationNames = @($NodeConfigurationName)
     }
 
     if($ReportOnly)
     {
         $RefreshMode = 'PUSH'
     }
     else
     {
         $RefreshMode = 'PULL'
     }
 
     Node $ComputerName
     {
         Settings
         {
             RefreshFrequencyMins           = $RefreshFrequencyMins
             RefreshMode                    = $RefreshMode
             ConfigurationMode              = $ConfigurationMode
             AllowModuleOverwrite           = $AllowModuleOverwrite
             RebootNodeIfNeeded             = $RebootNodeIfNeeded
             ActionAfterReboot              = $ActionAfterReboot
             ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
         }
 
         if(!$ReportOnly)
         {
         ConfigurationRepositoryWeb AzureAutomationStateConfiguration
             {
                 ServerUrl          = $RegistrationUrl
                 RegistrationKey    = $RegistrationKey
                 ConfigurationNames = $ConfigurationNames
             }
 
             ResourceRepositoryWeb AzureAutomationStateConfiguration
             {
                 ServerUrl       = $RegistrationUrl
                 RegistrationKey = $RegistrationKey
             }
         }
 
         ReportServerWeb AzureAutomationStateConfiguration
         {
             ServerUrl       = $RegistrationUrl
             RegistrationKey = $RegistrationKey
         }
     }
}
 
 # Create the metaconfigurations
 # NOTE: DSC Node Configuration names are case sensitive in the portal.
 # TODO: edit the below as needed for your use case
$Params = @{
     RegistrationUrl = 'https://86577507-3fa0-4bd0-bf31-c212e05f791f.agentsvc.brs.azure-automation.net/accounts/86577507-3fa0-4bd0-bf31-c212e05f791f';
     RegistrationKey = 'v8EGqcQykU5Cu3byLds3f37dehqNXPgzRb00Jc3bvdBN/DS9pHuWfdVciDpXut6IbkwYBHtJlUEG59wEEu8fVw==';
     ComputerName = @('otherVM');
     NodeConfigurationName = 'NewConfig2.AllNodes';
     RefreshFrequencyMins = 30;
     ConfigurationModeFrequencyMins = 15;
     RebootNodeIfNeeded = $False;
     AllowModuleOverwrite = $False;
     ConfigurationMode = 'ApplyAndMonitor';
     ActionAfterReboot = 'ContinueConfiguration';
     ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
}
 
# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params