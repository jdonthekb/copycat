# Add Windows Forms and Drawing libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Read the template and find tags
$templateContent = Get-Content 'template.ps1'
$tagPattern = "@@@(.*?)@@@"
$matches = [regex]::Matches($templateContent, $tagPattern)

$tags = New-Object System.Collections.ArrayList
foreach ($match in $matches) {
    $tagName = $match.Groups[1].Value
    if (-not $tags.Contains($tagName)) {
        $tags.Add($tagName) | Out-Null
    }
}


# Function to create input fields
function CreateInputField($form, $tag, [ref]$position, $isMultiline = $false) {
    $textBoxHeight = 20
    $positionIncrement = 45
    $scrollBars = 'None'
    if ($isMultiline) {
        $textBoxHeight = 60
        $positionIncrement = 85
        $scrollBars = 'Vertical'
    }

    $labelYPosition = $position.Value
    $textBoxYPosition = $labelYPosition + 20

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, $labelYPosition)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = "Enter ${tag}:"
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, $textBoxYPosition)
    $textBox.Size = New-Object System.Drawing.Size(260, $textBoxHeight)
    $textBox.Multiline = $isMultiline
    $textBox.ScrollBars = $scrollBars
    $textBox.Name = $tag
    $form.Controls.Add($textBox)

    $position.Value += $positionIncrement
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'CopyCat v1.2'
$form.StartPosition = 'CenterScreen'
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink'

# Initialize position
$position = 10

# Create input fields for each tag
foreach ($tag in $tags) {
    $isMultiline = $tag -eq "Description" # Adjust as necessary
    CreateInputField $form $tag ([ref]$position) $isMultiline
}

# Generate Button
$generateButton = New-Object System.Windows.Forms.Button
$generateButton.Location = New-Object System.Drawing.Point(10, $position)
$generateButton.Size = New-Object System.Drawing.Size(260, 30)
$generateButton.Text = 'Generate Script'
$generateButton.Add_Click({
    $scriptNameInputBox = $form.Controls["ScriptName"]
    $defaultFileName = if ($scriptNameInputBox.Text -ne '') { $scriptNameInputBox.Text } else { 'NewScript' }

    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "PowerShell Script (*.ps1)|*.ps1"
    $saveFileDialog.Title = "Save Generated Script"
    $saveFileDialog.FileName = $defaultFileName

    if ($saveFileDialog.ShowDialog() -eq 'OK') {
        $generatedScript = $templateContent
        foreach ($tag in $tags) {
            $inputBox = $form.Controls[$tag]
            if ($inputBox) {
                $inputValue = $inputBox.Text
                $generatedScript = $generatedScript -replace "@@@$tag@@@", $inputValue
            }
        }
        $generatedScript | Out-File -FilePath $saveFileDialog.FileName -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Script saved to $($saveFileDialog.FileName)")
    }
})
$form.Controls.Add($generateButton)

# Show the GUI
$form.ShowDialog()
# SIG # Begin signature block
# MIIFggYJKoZIhvcNAQcCoIIFczCCBW8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/esnBmkVTTHgztiKf2dvhM/4
# b+agggMWMIIDEjCCAfqgAwIBAgIQLOXnTOrsfbtMi7849WAAizANBgkqhkiG9w0B
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
# BgkqhkiG9w0BCQQxFgQUGwoybTIGp5NHAfIGhKAtNIrxG4YwDQYJKoZIhvcNAQEB
# BQAEggEA1Wn6ZaDC+fdBXp0z3m5Hi/NxGb0bdspjsxcA0XuYc9P2pNsDWjv9Lcrm
# hXe5zyBbp09estiZ7h6O0oM+8GyQc7cFvCVoWPKzuqZr4tFHh4lMjHu1dq3gTFq7
# yKVNSQS0+Gw2vDh6qLb3eqhbefMMyVoqJokM0+n/y1s24ZUFmKq9az5TUe5DLfYr
# Rv8qPZlMNde8IaGnjOOJPrCP4mYkAlXXLxmG++jSJ8L3pD6eSHt0Yv7c+qbQAZLD
# dJEYqG/fqYJqq0v9Dr9y2jrIvxD9rAs2DYp13T7DNZj35XTmMSPKgRE88ORdCY65
# d2Ax3yDbm7q/UslPUIt+nIqogI9wfA==
# SIG # End signature block
