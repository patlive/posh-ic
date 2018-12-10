<#
# AUTHOR : Dave May
#>

function New-ICAction() # {{{2
{
# Documentation {{{3
<#
.SYNOPSIS
  Creates a new IC action
.DESCRIPTION
  Creates a new IC action
.PARAMETER ICSession
  The Interaction Center Session
.PARAMETER ICAction
  The Interaction Center Action
#> # }}}3
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)] [Alias("Session", "Id")] [ININ.ICSession] $ICSession,
    [Parameter(Mandatory=$true)] [Alias("Action")] [string] $ICAction
  )

  $actionExists = Get-ICAction $ICSession -ICAction $ICAction
  if (-not ([string]::IsNullOrEmpty($actionExists))) {
    return
  }

  $headers = @{
    "Accept-Language"      = $ICSession.language;
    "ININ-ICWS-CSRF-Token" = $ICSession.token;
  }

  $body = ConvertTo-Json(@{
   "configurationId" = New-ICConfigurationId $ICAction
  })

  $response = Invoke-RestMethod -Uri "$($ICsession.baseURL)/$($ICSession.id)/configuration/actions" -Body $body -Method Post -Headers $headers -WebSession $ICSession.webSession -ErrorAction Stop
  Write-Output $response | Format-Table
  [PSCustomObject] $response
} # }}}2

