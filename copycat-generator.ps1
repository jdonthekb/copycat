# Add Windows Forms and Drawing libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Read the template and find tags
$templateContent = Get-Content 'template.ps1'
$tagPattern = "@@@(.*?)@@@"
$matches = [regex]::Matches($templateContent, $tagPattern)

$tags = @{}
foreach ($match in $matches) {
    $tagName = $match.Groups[1].Value
    if (-not $tags.ContainsKey($tagName)) {
        $tags[$tagName] = $null
        Write-Host "Found tag: $tagName"
    }
}

# Function to create input fields
function CreateInputField($form, $tag, [ref]$position) {
    Write-Host "Creating input field for: $tag"

    $labelLocationY = $position.Value
    $textBoxLocationY = $labelLocationY + 20

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, $labelLocationY)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = "Enter ${tag}:"
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, $textBoxLocationY)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $textBox.Name = $tag
    $form.Controls.Add($textBox)

    $position.Value += 50
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'PowerShell Script Generator'
$form.StartPosition = 'CenterScreen'

# Create input fields dynamically
$position = 20
foreach ($tag in $tags.Keys) {
    CreateInputField $form $tag ([ref]$position)
}

# Generate Button
$generateButton = New-Object System.Windows.Forms.Button
$generateButton.Location = New-Object System.Drawing.Point(10, $position)
$generateButton.Size = New-Object System.Drawing.Size(260, 30)
$generateButton.Text = 'Generate Script'
$generateButton.Add_Click({
    $generatedScript = $templateContent
    foreach ($tag in $tags.Keys) {
        $inputBox = $form.Controls.Find($tag, $true)
        if ($inputBox -and $inputBox.Count -gt 0) {
            $inputValue = $inputBox[0].Text
            $generatedScript = $generatedScript -replace "@@@$tag@@@", $inputValue
        }
    }
    # Save or do something with the generated script
    # For example: $generatedScript | Out-File "GeneratedScript.ps1"
    [System.Windows.Forms.MessageBox]::Show("Script Generated!")
})
$form.Controls.Add($generateButton)

# Adjust form size based on content
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink'

# Show the GUI
$form.ShowDialog()

# SIG # Begin signature block
# MIIFggYJKoZIhvcNAQcCoIIFczCCBW8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQULqJW2qC7y2whbzHAuP8u9K6n
# gvugggMWMIIDEjCCAfqgAwIBAgIQLOXnTOrsfbtMi7849WAAizANBgkqhkiG9w0B
# AQsFADAhMR8wHQYDVQQDDBZDSEVTSS1Db2RlU2lnbi1KRC0yMDI0MB4XDTIzMTEx
# OTE5NDEzOVoXDTI0MTExOTIwMDEzOVowITEfMB0GA1UEAwwWQ0hFU0ktQ29kZVNp
# Z24tSkQtMjAyNDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPLupOwP
# zQtFN22nZD29Yqkuqwb5LXLJaxVJzWF38sns0Rax7Fr6haZNxmbVmZw4SWhvYDes
# jR98yXqjMELpvt3ZEhccopEm8LmF1mjGvHBIhD9bya6NbDqv8RyIym6DanS72KQi
# ezYcvhGKc3pDIkyIYGWSjDSnLjAFUxqhgWwhVGjqStjoJNl3p0qI9U/Pd+a2INys
# TfiTsaQ8eQhqVkc7w0hBulq46QgqcnbTmqtwhJGyMsej47DND9IfqULB42xmtDDa
# XfzQQdq6GU5vINm+2h0Gv5iLKmjSZjOG+/7FzgNBxaPC0Z07dGGzxzEm40mw/ufe
# gki02fPb4prDKg0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMB0GA1UdDgQWBBTbV2TSWoTH1WlvUao+edP/mlTetDANBgkqhkiG
# 9w0BAQsFAAOCAQEASFqUcORM/DGlMCGom0Om+WYZAcv+7haMd3RKIvM3ApsM0HOG
# CGYkQjVchY1pDlBE+hN14WiskS4sHi+BwrMQcqmMKbDdn6gdCnR/hJ8d1Vn+/ikS
# R7X0kqvUdvrEjSscHv+KwIK4zpYvne+4zLUTQaYC13SrlakuezjxJQcNr78qeEXT
# JoIqQmp54Lbw6nIyHAVz+L2IxSUWZOBth383J2FZXjH31CRhLLTwGzE7dyW4cDPj
# MolWgY0BfNTlIj9+s1a0rj3T2s2UiNsjSQnwuwtTsQozH6MS6o6RnxP2XeNl1fOc
# 4dTS7Wh7Hu95i9J+5A9AVSfvXPqnPiTcQB4JvzGCAdYwggHSAgEBMDUwITEfMB0G
# A1UEAwwWQ0hFU0ktQ29kZVNpZ24tSkQtMjAyNAIQLOXnTOrsfbtMi7849WAAizAJ
# BgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0B
# CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAj
# BgkqhkiG9w0BCQQxFgQUQhHDdAXyNh2UHEVYx68ZWjrMcCQwDQYJKoZIhvcNAQEB
# BQAEggEAEDYncmvcIarMnjT9sQZqxfrWtHGDqTFqBkHMe1PhqCdFbD3Taqe0a08J
# xp3p5baDNFzYd6fTNcUJEnkUYomQ/SJ9hhSes8FDU7LZSWd/UXnkwTONZBfL86H7
# HgbyqzNPXQNWOXQH9JGZUFBzqIyiD1r5sV+42rSkC9Liysr+4H+WMiGVg5tqCOOO
# xMFRfGawbqWNgWnBl+SgFmUq8Ti8+6qxjDm4kQQDP7+8CbIabubAdkq53mtphBqs
# FRpOhYln8CEDkgw3Ihmioc7Jism4sglrsw//ucYo+GJrQNM/vhP63MdNz7vaD9X9
# AIlCXas5tsJVvI61RFUTKau2EKz7vw==
# SIG # End signature block
