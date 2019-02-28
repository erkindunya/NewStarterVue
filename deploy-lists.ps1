$templatePath = 'D:\TFS PROD\ITnewStarters\lists\template.xml'
#Connect-PnPOnline -Url "https://kier.sharepoint.com/sites/ITRequestsPortal/" -UseWebLogin
Connect-PnPOnline -Url "https://kier77.sharepoint.com/ITRequestsPortal/" -UseWebLogin
Apply-PnPProvisioningTemplate -path $templatePath -overwrite
Add-PnPListItem -List "New Starter Submissions" -ContentType "NewStarterSubmissions" -Values @{"Title" = "Test Title"}

