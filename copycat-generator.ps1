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
