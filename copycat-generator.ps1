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
    }
}

# Function to create input fields
function CreateInputField($form, $tag, [ref]$position) {
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, $position.Value)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = "Enter $tag:"
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, $position.Value + 20)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $textBox.Name = $tag
    $form.Controls.Add($textBox)

    $position.Value += 40
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
        $inputBox = $form.Controls[$tag]
        if ($inputBox) {
            $inputValue = $inputBox.Text
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
