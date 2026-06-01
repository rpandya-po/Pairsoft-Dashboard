Write-Host "Script started..."

$connectionString = "Server=INL-40H9F9-PSFT;Database=AzureDashboard;User Id=AzUser;Password=AzUser@123;TrustServerCertificate=True;"

try {
    Write-Host "Connecting..."

    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = $connectionString
    $conn.Open()

    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT * FROM dbo.WorkItems"

    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $cmd
    $table = New-Object System.Data.DataTable

    $adapter.Fill($table)

    Write-Host "Rows fetched:" $table.Rows.Count

    # 🔥 Convert only needed columns (IMPORTANT)
    $result = $table | Select-Object WorkItemId, ProjectName, State, Severity, AssignedTo, CustomerName, CustomerStatus, CreatedOn

    $result | ConvertTo-Json -Depth 3 | Set-Content -Encoding UTF8 data.json

    Write-Host "data.json created!"

    $conn.Close()
}
catch {
    Write-Host "ERROR:"
    Write-Host $_
}

Write-Host "Done!"