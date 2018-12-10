<#
# AUTHOR : Dave May
#>

function Get-ICAction() # {{{2
{
# Documentation {{{3
<#
.SYNOPSIS
  Gets an action
.DESCRIPTION
  Gets an action
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

  $headers = @{
    "Accept-Language"      = $ICSession.language;
    "ININ-ICWS-CSRF-Token" = $ICSession.token;
  }

  $query = "/?select=*"

  $response = '';

  try
  {
    $response = Invoke-RestMethod -Uri "$($ICsession.baseURL)/$($ICSession.id)/configuration/actions/$ICAction$($query)" -Method Get -Headers $headers -WebSession $ICSession.webSession -ErrorAction Stop
    Write-Verbose "Response: $response"
  }
  catch [System.Net.WebException]
  {
    # If action not found, ignore the exception
    if (-not ($_.Exception.message -match '404'))
    {
        Write-Error $_
    }
  }
  [PSCustomObject] $response
} # }}}2

