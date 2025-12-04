# PowerShell script to batch update navigation calls

$files = @(
    "lib\features\home\presentation\widgets\nearby_fields_preview.dart",
    "lib\features\home\presentation\widgets\categories_slider.dart",
    "lib\features\home\presentation\widgets\quick_booking_shortcuts.dart",
    "lib\features\home\presentation\widgets\explore_section.dart",
    "lib\features\home\presentation\widgets\home_quick_actions.dart",
    "lib\features\bookings\presentation\widgets\booking_list_item.dart",
    "lib\features\settings\presentation\pages\user_settings_page.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing: $file"
        
        # Read content
        $content = Get-Content $file -Raw
        
        # Replace imports
        $content = $content -replace "import 'package:spo_kick/core/routes/app_router.dart';", ""
        if ($content -notmatch "import 'package:go_router/go_router.dart';") {
            $content = $content -replace "(import 'package:flutter/material.dart';)", "`$1`nimport 'package:go_router/go_router.dart';"
        }
        
        # Save
        Set-Content -Path $file -Value $content -NoNewline
    }
}

Write-Host "Import updates complete!"
