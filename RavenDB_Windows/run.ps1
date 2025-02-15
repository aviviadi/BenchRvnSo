#Requires -Version 4.0

function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value;
    Split-Path $Invocation.MyCommand.Path;
}

$ErrorActionPreference = "Stop";

$scriptDirectory = Get-ScriptDirectory;
$versionPath = Join-Path $scriptDirectory "version.txt";
$executable = "Raven.Server.exe";
$executableDir = Join-Path $scriptDirectory "Server"
$executablePath = Join-Path $executableDir $executable;
$assemblyVersion =  & $executablePath --version;
$version = $null;

if (Test-Path $versionPath) {
    $version = Get-Content -Path $versionPath;
}

if ($version -ne $assemblyVersion) {
    Set-Content -Path $versionPath $assemblyVersion;
    Start-Process "http://ravendb.net/first-run?type=start&ver=$assemblyVersion";
}

$args = @( "--browser" );

Push-Location $executableDir;

Try
{
    Invoke-Expression -Command ".\$executable $args";
    if ($LASTEXITCODE -ne 0) { 
        Read-Host -Prompt "Press enter to continue...";
    }
}
Finally
{
    Pop-Location;
}

# SIG # Begin signature block
# MIIeggYJKoZIhvcNAQcCoIIeczCCHm8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/oQr/K5V6ZPnlNtCVK9zufr0
# RS+gghj3MIIEfTCCA2WgAwIBAgIDG+cVMA0GCSqGSIb3DQEBCwUAMGMxCzAJBgNV
# BAYTAlVTMSEwHwYDVQQKExhUaGUgR28gRGFkZHkgR3JvdXAsIEluYy4xMTAvBgNV
# BAsTKEdvIERhZGR5IENsYXNzIDIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcN
# MTQwMTAxMDcwMDAwWhcNMzEwNTMwMDcwMDAwWjCBgzELMAkGA1UEBhMCVVMxEDAO
# BgNVBAgTB0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxGjAYBgNVBAoTEUdv
# RGFkZHkuY29tLCBJbmMuMTEwLwYDVQQDEyhHbyBEYWRkeSBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAv3FiCPH6WTT3G8kYo/eASVjpIoMTpsUgQwE7hPHmhUmfJ+r2hBtOoLTbcJjH
# MgGxBT4HTu70+k8vWTAi56sZVmvigAf88xZ1gDlRe+X5NbZ0TqmNghPktj+pA4P6
# or6KFWp/3gvDthkUBcrqw6gElDtGfDIN8wBmIsiNaW02jBEYt9OyHGC0OPoCjM7T
# 3UYH3go+6118yHz7sCtTpJJiaVElBWEaRIGMLKlDliPfrDqBmg4pxRyp6V0etp6e
# MAo5zvGIgPtLXcwy7IViQyU0AlYnAZG0O3AqP26x6JyIAX2f1PnbU21gnb8s51ir
# uF9G/M7EGwM8CetJMVxpRrPgRwIDAQABo4IBFzCCARMwDwYDVR0TAQH/BAUwAwEB
# /zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFDqahQcQZyi27/a9BUFuIMGU2g/e
# MB8GA1UdIwQYMBaAFNLEsNKR1EwRcbNhyz2h/t2oatTjMDQGCCsGAQUFBwEBBCgw
# JjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZ29kYWRkeS5jb20vMDIGA1UdHwQr
# MCkwJ6AloCOGIWh0dHA6Ly9jcmwuZ29kYWRkeS5jb20vZ2Ryb290LmNybDBGBgNV
# HSAEPzA9MDsGBFUdIAAwMzAxBggrBgEFBQcCARYlaHR0cHM6Ly9jZXJ0cy5nb2Rh
# ZGR5LmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEAWQtTvZKGEack
# e+1bMc8dH2xwxbhuvk679r6XUOEwf7ooXGKUwuN+M/f7QnaF25UcjCJYdQkMiGVn
# OQoWCcWgOJekxSOTP7QYpgEGRJHjp2kntFolfzq3Ms3dhP8qOCkzpN1nsoX+oYgg
# HFCJyNwq9kIDN0zmiN/VryTyscPfzLXs4Jlet0lUIDyUGAzHHFIYSaRt4bNYC8nY
# 7NmuHDKOKHAN4v6mF56ED71XcLNa6R+ghlO773z/aQvgSMO3kwvIClTErF0UZzds
# yqUvMQg3qm5vjLyb4lddJIGvl5echK1srDdMZvNhkREg5L4wn3qkKQmw4TRfZHcY
# QFHfjDCmrzCCBNAwggO4oAMCAQICAQcwDQYJKoZIhvcNAQELBQAwgYMxCzAJBgNV
# BAYTAlVTMRAwDgYDVQQIEwdBcml6b25hMRMwEQYDVQQHEwpTY290dHNkYWxlMRow
# GAYDVQQKExFHb0RhZGR5LmNvbSwgSW5jLjExMC8GA1UEAxMoR28gRGFkZHkgUm9v
# dCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgLSBHMjAeFw0xMTA1MDMwNzAwMDBaFw0z
# MTA1MDMwNzAwMDBaMIG0MQswCQYDVQQGEwJVUzEQMA4GA1UECBMHQXJpem9uYTET
# MBEGA1UEBxMKU2NvdHRzZGFsZTEaMBgGA1UEChMRR29EYWRkeS5jb20sIEluYy4x
# LTArBgNVBAsTJGh0dHA6Ly9jZXJ0cy5nb2RhZGR5LmNvbS9yZXBvc2l0b3J5LzEz
# MDEGA1UEAxMqR28gRGFkZHkgU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eSAt
# IEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAueDLENSvdr3Uk2Lr
# MGS4gQhswwTZYheOL/8+Zc+PzmLmPFIc2hZFS1WreGtjg2KQzg9pbJnIGhSLTMxF
# M+qI3J6jryv+gGGdeVfEzy70PzA8XUf8mha8wzeWQVGOEUtU+Ci+0Iy+8DA4HvOw
# JvhmR2Nt3nEmR484R1PRRh2049wA6kWsvbxx2apvANvbzTA6eU9fTEf4He9bwsSd
# YDuxskOR2KQzTuqz1idPrSWKpcb01dCmrnQFZFeItURV1C0qOj74uL3pMgoClGTE
# FjpQ8Uqu53kzrwwgB3/o3wQ5wmkCbGNS+nfBG8h0h8i5kxhQVDVLaU68O9NJLh/c
# wdJS+wIDAQABo4IBGjCCARYwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
# AQYwHQYDVR0OBBYEFEDCvSeOzDSDMKIz1/tss/C0LIDOMB8GA1UdIwQYMBaAFDqa
# hQcQZyi27/a9BUFuIMGU2g/eMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZ29kYWRkeS5jb20vMDUGA1UdHwQuMCwwKqAooCaGJGh0dHA6
# Ly9jcmwuZ29kYWRkeS5jb20vZ2Ryb290LWcyLmNybDBGBgNVHSAEPzA9MDsGBFUd
# IAAwMzAxBggrBgEFBQcCARYlaHR0cHM6Ly9jZXJ0cy5nb2RhZGR5LmNvbS9yZXBv
# c2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEACH5skxDIOLiWqZBL/6FfTwTvbD6c
# iAbJUI+mc/dXMRu+vOQv2/i601vgtOfmeWIODKLXamNzMbX1qEikOwgtol2Q17R8
# JU8RVjDEtkSdeyyd5V7m7wxhqr/kKhvuhJ64g33BQ85EpxNwDZEf9MgTrYNg2dhy
# qHMkHrWsIg7KF4liWEQbq4klAQAPzcQbYttRtNMPUSqb9Lxz/HbONqTN2dgs6q6b
# 9SqykNFNdRiKP4pBkCN9W0v+pANYm0ayw2Bgg/h9UEHOwqGQw7vvAi/SFVTuRBXZ
# Cq6nijPtsS12NibcBOuf92EfFdyHb+5GliitoSZ9CgmnLgSjjbz4vAQwATCCBQAw
# ggPooAMCAQICAQcwDQYJKoZIhvcNAQELBQAwgY8xCzAJBgNVBAYTAlVTMRAwDgYD
# VQQIEwdBcml6b25hMRMwEQYDVQQHEwpTY290dHNkYWxlMSUwIwYDVQQKExxTdGFy
# ZmllbGQgVGVjaG5vbG9naWVzLCBJbmMuMTIwMAYDVQQDEylTdGFyZmllbGQgUm9v
# dCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgLSBHMjAeFw0xMTA1MDMwNzAwMDBaFw0z
# MTA1MDMwNzAwMDBaMIHGMQswCQYDVQQGEwJVUzEQMA4GA1UECBMHQXJpem9uYTET
# MBEGA1UEBxMKU2NvdHRzZGFsZTElMCMGA1UEChMcU3RhcmZpZWxkIFRlY2hub2xv
# Z2llcywgSW5jLjEzMDEGA1UECxMqaHR0cDovL2NlcnRzLnN0YXJmaWVsZHRlY2gu
# Y29tL3JlcG9zaXRvcnkvMTQwMgYDVQQDEytTdGFyZmllbGQgU2VjdXJlIENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEA5ZBmS+z5RnGpIIO+6Wy/SslIaYF1Tm0k9ssXE/iwcVmEemsrhaQ0tRbl
# y8zpQXAspC7W+jJ94ajelBCsMcHA2Gr/WSerdtb8C3RruKeuP8RU9LQxRN2TVoyk
# TF6bicskg5viV3232BIfyYVt9NGA8VCbh67UCxAF+ye6KG0X6Q7WTbk5VQb/CiQF
# fi/GHXJs1IspjFd92tnrZhrTT6fff1LEMMWlyQ4CxVO/dzhoBiTDZsg3fjAeRXEj
# Nf+Q2Cqdjeewkk08fyoKk9zNFkZl92CEi3ZLkSdzFJLg6u6PFuqNDj52F799iYCA
# REPnLeBDCXXaNuit24k69V0SjiMEgwIDAQABo4IBLDCCASgwDwYDVR0TAQH/BAUw
# AwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFCVFgWhQJjg9Oy0svs1q2bY9
# s2ZjMB8GA1UdIwQYMBaAFHwMMh+n2TB/xH1oo2Kooc6rB1snMDoGCCsGAQUFBwEB
# BC4wLDAqBggrBgEFBQcwAYYeaHR0cDovL29jc3Auc3RhcmZpZWxkdGVjaC5jb20v
# MDsGA1UdHwQ0MDIwMKAuoCyGKmh0dHA6Ly9jcmwuc3RhcmZpZWxkdGVjaC5jb20v
# c2Zyb290LWcyLmNybDBMBgNVHSAERTBDMEEGBFUdIAAwOTA3BggrBgEFBQcCARYr
# aHR0cHM6Ly9jZXJ0cy5zdGFyZmllbGR0ZWNoLmNvbS9yZXBvc2l0b3J5LzANBgkq
# hkiG9w0BAQsFAAOCAQEAVmXK/vM/CqiTixjH3kNpEzQgvk5feKhrnNtqTUHbwRPs
# 3DEAIl73AJ4M4DRlNPmxOk5IyBKBiFxbPghTevcaZN+4UGHMU1FAKUvC9K46X+TK
# rSbMTmFD5f1XpjdwzkMrsJTDkunhX6oQSbdp5ODQH2SkK80fb6D4hCQYznk9qZG/
# VBgTiZlUEQ1VxSYLeU9aHG75Y9sUgKQHq/qypbmI3ZH+ZTuko3m+iU3h0LD0yBcM
# CpYUfAm3bOHC2FXUGKCqQWlwJKO57+la3D7rlErwt95fDnb6+/tpA0VAUO5yDKQS
# hoHNE9FOxDzKTg3SJvEAt7SmouFueoH9MKx6H8dZezCCBRowggQCoAMCAQICCGHO
# Wwn6DuBiMA0GCSqGSIb3DQEBCwUAMIG0MQswCQYDVQQGEwJVUzEQMA4GA1UECBMH
# QXJpem9uYTETMBEGA1UEBxMKU2NvdHRzZGFsZTEaMBgGA1UEChMRR29EYWRkeS5j
# b20sIEluYy4xLTArBgNVBAsTJGh0dHA6Ly9jZXJ0cy5nb2RhZGR5LmNvbS9yZXBv
# c2l0b3J5LzEzMDEGA1UEAxMqR28gRGFkZHkgU2VjdXJlIENlcnRpZmljYXRlIEF1
# dGhvcml0eSAtIEcyMB4XDTE3MDcwMzEwMzUwMloXDTIwMDcwMzEwMzUwMlowXDEL
# MAkGA1UEBhMCSUwxEzARBgNVBAcTClNkZSBJdHpoYWsxGzAZBgNVBAoTEkhpYmVy
# bmF0aW5nIFJoaW5vczEbMBkGA1UEAxMSSGliZXJuYXRpbmcgUmhpbm9zMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAovpgW5SVVTuYzqYQR0zCIQ6qlRiW
# kdVnbtnvIZGLtQhe0NjR0BizkFofjbnz6v7Cxe8uTeSnFwjiAxaokm+bp8rl1eIa
# c72DzWIkBPNYQbQoqmVeKJBqcxhHN+Sus0mV9FK7neJoURbSeCemsthVQzrhRbGa
# tJV2+akL7yDa/MewHy09xuALt1wrcXew5scHCghEMcrTfF5VAS64fQAfQyXCibJt
# bmHc2SJExyQeedKDmshbNLM0e5i70sLS7bjnvbtrFYfSAaWlGHQcNBQ9DZmXUm26
# v0yfykJubyic3p9k+mZcyDknT/8a5YsA7FfyMhLV8O1ZDRTX/3XQCaQGrQIDAQAB
# o4IBhTCCAYEwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzAOBgNV
# HQ8BAf8EBAMCB4AwNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL2NybC5nb2RhZGR5
# LmNvbS9nZGlnMnM1LTMuY3JsMF0GA1UdIARWMFQwSAYLYIZIAYb9bQEHFwIwOTA3
# BggrBgEFBQcCARYraHR0cDovL2NlcnRpZmljYXRlcy5nb2RhZGR5LmNvbS9yZXBv
# c2l0b3J5LzAIBgZngQwBBAEwdgYIKwYBBQUHAQEEajBoMCQGCCsGAQUFBzABhhho
# dHRwOi8vb2NzcC5nb2RhZGR5LmNvbS8wQAYIKwYBBQUHMAKGNGh0dHA6Ly9jZXJ0
# aWZpY2F0ZXMuZ29kYWRkeS5jb20vcmVwb3NpdG9yeS9nZGlnMi5jcnQwHwYDVR0j
# BBgwFoAUQMK9J47MNIMwojPX+2yz8LQsgM4wHQYDVR0OBBYEFDEZQ5iQM0nJVqtC
# LfaDeVbLgMHOMA0GCSqGSIb3DQEBCwUAA4IBAQBV9XcfGc2Cic6ll7Ecf1veL3Y+
# 8U0lOZ7+hpgfeTxkCDJlRDf7r/UlflHZ0ZhJY7KfidZgB7VIvw34O5GqvJR36NvP
# YU9aVku3HEtJQbKlpsOir6g9LWBqG30Narhy3RqC7J3v+r//CMASjSBrGdP+1Cfe
# KmiGKLJSl17S9mn1SIenq4xUMsCOZPB42aFjGMQFcRzTv96aAQ7WX+CG8Zp7U79a
# dXnADw+GlqkFQjPwnsAQ6NstfKYg3jK5OvFIin2NKwoyc/dKamn99lUeIIEq9T/r
# txUJ93avvLLkbKkguBk8g7u+jnVgd4XPQDCQzy7tW1XjRYfRSMUMr3XstSj6MIIF
# fDCCBGSgAwIBAgIIH9xY6WYITA4wDQYJKoZIhvcNAQELBQAwgcYxCzAJBgNVBAYT
# AlVTMRAwDgYDVQQIEwdBcml6b25hMRMwEQYDVQQHEwpTY290dHNkYWxlMSUwIwYD
# VQQKExxTdGFyZmllbGQgVGVjaG5vbG9naWVzLCBJbmMuMTMwMQYDVQQLEypodHRw
# Oi8vY2VydHMuc3RhcmZpZWxkdGVjaC5jb20vcmVwb3NpdG9yeS8xNDAyBgNVBAMT
# K1N0YXJmaWVsZCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IC0gRzIwHhcN
# MTgxMDE2MDcwMDAwWhcNMjMxMDE2MDcwMDAwWjCBhzELMAkGA1UEBhMCVVMxEDAO
# BgNVBAgTB0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxJDAiBgNVBAoTG1N0
# YXJmaWVsZCBUZWNobm9sb2dpZXMsIExMQzErMCkGA1UEAxMiU3RhcmZpZWxkIFRp
# bWVzdGFtcCBBdXRob3JpdHkgLSBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAM6vIONtCudqEs8F/KvxFebFWIXYSc63OfxUG4kDq2sdD2WDKASnpyVq
# PbEUJMKpK8aEy86M8z6lPyxth+ZJ5MOtuXEjBwe+BRh7Tx4xI7uLX50BQyPlz80R
# ob0jzK8z74OcxhlU/xZLuc/gI1OizzzRVker8VbM9WatMunEiy9IiaIz9NUkelbX
# zacwzAru6fDrabbR/xhv6IY9wzLq79DQq3q86I85lhK+aBvJ9qrVQIdhfypm8zZk
# NsBzcxlRRpvWAdYlXRvTPle8wLNx2G50iShYvpNeFBYBGGolZ4cUQkvikRMvJxD2
# helCCNehcZt4CYSYTrt89uWD5JO+D2ECAwEAAaOCAakwggGlMAwGA1UdEwEB/wQC
# MAAwDgYDVR0PAQH/BAQDAgbAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMB0GA1Ud
# DgQWBBR6q6kuLchs4yV49kbWxZsIun8q7zAfBgNVHSMEGDAWgBQlRYFoUCY4PTst
# LL7Natm2PbNmYzCBhAYIKwYBBQUHAQEEeDB2MCoGCCsGAQUFBzABhh5odHRwOi8v
# b2NzcC5zdGFyZmllbGR0ZWNoLmNvbS8wSAYIKwYBBQUHMAKGPGh0dHA6Ly9jcmwu
# c3RhcmZpZWxkdGVjaC5jb20vcmVwb3NpdG9yeS9zZl9pc3N1aW5nX2NhLWcyLmNy
# dDBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vY3JsLnN0YXJmaWVsZHRlY2guY29t
# L3JlcG9zaXRvcnkvbWFzdGVyc3RhcmZpZWxkMmlzc3VpbmcuY3JsMFAGA1UdIARJ
# MEcwRQYLYIZIAYb9bgEHFwIwNjA0BggrBgEFBQcCARYoaHR0cDovL2NybC5zdGFy
# ZmllbGR0ZWNoLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEAuBRG
# j0w7m/m/zG7HsLuyiJcTYdfeaFF8qZ48ImAIV/0y87l9pNjjIIy1e+NRFD7vlySp
# KM/iqFFdpZELuYUFf3QAPcathvKXc5ThpwPozV4ZnWdVDeifiUlvnFTK9bLnvLqy
# /spOCjGIQGSLBLDmtJTCOy4c9Olg0xmGI8gQ26xwHtYZsFqEayJW6VkhrDklJP8W
# NFRwrw1Y1rybg8X69BgmjA8DlfJkOFnQ4JY4LA5IlhIbSrPTx1gQEom8+HFhDCu2
# +6GKbm734gD3zvfCIXzLKHq7T/WqhDfJ/bhhA3aj5popw6z8nrbMVzalXosnnBMu
# P2vF33RJCKTtWGvM6jGCBPUwggTxAgEBMIHBMIG0MQswCQYDVQQGEwJVUzEQMA4G
# A1UECBMHQXJpem9uYTETMBEGA1UEBxMKU2NvdHRzZGFsZTEaMBgGA1UEChMRR29E
# YWRkeS5jb20sIEluYy4xLTArBgNVBAsTJGh0dHA6Ly9jZXJ0cy5nb2RhZGR5LmNv
# bS9yZXBvc2l0b3J5LzEzMDEGA1UEAxMqR28gRGFkZHkgU2VjdXJlIENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAtIEcyAghhzlsJ+g7gYjAJBgUrDgMCGgUAoIGYMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBTmenbF2DXX2WEu12oIKV2Wxx6HGDA4BgorBgEE
# AYI3AgEMMSowKKAQgA4AUgBhAHYAZQBuAEQAQqEUgBJodHRwOi8vcmF2ZW5kYi5u
# ZXQwDQYJKoZIhvcNAQEBBQAEggEAg7bqjPVsdtEKaYMhp2opZqEkWP7nF8eYoy2/
# G3aSus/Ht7Bgn/qj0yCaSkuEGqCppXMONuEUL8+fxdW0ws2te0N6jh6+rFvEKj6T
# c5aoXM4lk9Y7teTcBW2WBZ5VPuWuTZKyrY6jN8qtp/r3m4cBdRa5LTO/iaIcJKF0
# vElpgO32LiMKNIi2x0Sg81dKg0UZzv5O5Id00ToJLnkUkib+7y+qj8r55WnCnRpQ
# ou2R2QCtRUDA5M4ri5xbRq+TR2EA2wPRVpA9UYYuXHU/XoxBfYfgQuD0AtQ0hsLW
# KYEF84QjbSflEg3fI8hM1Jr19lnEMJWi0jiQi/rVS1LiRwGIBqGCAm0wggJpBgkq
# hkiG9w0BCQYxggJaMIICVgIBATCB0zCBxjELMAkGA1UEBhMCVVMxEDAOBgNVBAgT
# B0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxJTAjBgNVBAoTHFN0YXJmaWVs
# ZCBUZWNobm9sb2dpZXMsIEluYy4xMzAxBgNVBAsTKmh0dHA6Ly9jZXJ0cy5zdGFy
# ZmllbGR0ZWNoLmNvbS9yZXBvc2l0b3J5LzE0MDIGA1UEAxMrU3RhcmZpZWxkIFNl
# Y3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgLSBHMgIIH9xY6WYITA4wCQYFKw4D
# AhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
# DTE5MDIxMzIyMDAyN1owIwYJKoZIhvcNAQkEMRYEFILIK8/3LHYehR51M5az6Yxz
# uWx/MA0GCSqGSIb3DQEBAQUABIIBAMTTs1c8dxGebCJ26p0ybC+9fZ2LKrCKEQu2
# 2OxV2yX00MIOLkC3Dhn6WxUf+WwkcDeleItOa4kxRTfMERKc6SRUL7Bv8bIXCkar
# QUSRwDuBcsG5TsLjKe5mDRDSujzAKAi+etYiws6UTTvjSK+izDGWstsDSTCPWGqB
# RBgai0Y8qKw4fggkcFM2IVMU++t7RoBxUbD4YGV3QbfbHlU6z647py3FbNtZeIWu
# 4qG2w6k7aOwSeqgHlOoZiPr6UGwyXfgHzamyRGKcJ7OeJLtdRtuGFCrD5PsQ2/wL
# lMwJkUkCRxnxd8XuscToR565IYOh1MKbuFP5wPNroUVO29GmR/0=
# SIG # End signature block
