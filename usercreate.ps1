$SqlServerName = "promitx-qa.database.windows.net"
$DatabaseName = "Sql-QA-DataOps-EUS"
$AdminUsername = "promitqa"
$AdminPassword = "FlipFlop@123"
$CsvFilePath = "C:\Users\promi\OneDrive\Documents\AutomatedSQL\users.csv"

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SqlServerName; Database = $DatabaseName; Integrated Security = False; User ID = $AdminUsername; Password = $AdminPassword;"
$SqlConnection.Open()

$CsvData = Import-Csv -Path $CsvFilePath

foreach ($User in $CsvData) {
    $UserName = $User.UserName
    $Password = $User.Password
    
    $SqlCommand = $SqlConnection.CreateCommand()
    $SqlCommand.CommandText = "CREATE USER [$UserName] WITH PASSWORD = '$Password';"
    $SqlCommand.ExecuteNonQuery()
}
catch {
    Write-Host "Error creating database user ${Username}: $_"
    return -1
}

$SqlConnection.Close()
