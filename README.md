# CopyCat PowerShell Script Generator

## Overview
CopyCat is a dynamic PowerShell script generator that creates customized scripts based on a template file. It provides a GUI for users to input parameters, which are then used to generate a PowerShell script. This tool is particularly useful for automating repetitive scripting tasks and ensuring consistency across script generations.

## Features
- **Dynamic GUI**: Automatically generates input fields based on tags found in the template script.
- **Customizable Template**: Use any `template.ps1` file to define the structure of the generated script.
- **Auto-Save Functionality**: Includes a Save File dialog to choose where to save the generated script.
- **Order Preservation**: Maintains the order of parameters as they appear in the template.

## Getting Started
To use CopyCat, you'll need a template PowerShell script (`template.ps1`) with placeholders in the format `@@@placeholder@@@`. CopyCat will read this file and generate a GUI with input fields corresponding to each placeholder.

### Prerequisites
- Windows Operating System
- PowerShell 5.1 or higher

### Running CopyCat
1. Clone or download this repository to your local machine.
2. Place your `template.ps1` file in the same directory as `CopyCat`.
3. Run `copycat-generator.ps1` to open the GUI.
4. Enter the required information in the GUI fields.
5. Click 'Generate Script' to save the generated PowerShell script to your desired location.

## How It Works
CopyCat reads a template PowerShell script and uses regular expressions to find and process placeholders marked by `@@@`. It then creates a GUI with input fields for each unique placeholder found. Users can input their desired values, and upon clicking 'Generate Script', CopyCat replaces placeholders in the template with these values and saves the new script.

## Customizing Your Template
Your `template.ps1` can include any valid PowerShell script structure. Use the `@@@placeholder@@@` format to mark areas in the script where you want user input to be inserted. For example:

```powershell
param (
    $Param1 = "@@@param1@@@",
    $Param2 = "@@@param2@@@"
)
# Rest of your script
