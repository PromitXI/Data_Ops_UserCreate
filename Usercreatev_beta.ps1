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
    
    # Check if user already exists
    $UserExistsCommand = $SqlConnection.CreateCommand()
    $UserExistsCommand.CommandText = "SELECT COUNT(*) FROM sys.database_principals WHERE name = '$UserName'"
    $UserExists = $UserExistsCommand.ExecuteScalar()
    
    if ($UserExists -eq 1) {
        # User already exists, print message and skip user
        Write-Host "User $UserName already exists, skipping..."
    }
    else {
        # User does not exist, create user and print message
        $SqlCommand = $SqlConnection.CreateCommand()
        $SqlCommand.CommandText = "CREATE USER [$UserName] WITH PASSWORD = '$Password';"
        $SqlCommand.ExecuteNonQuery()
        Write-Host "User $UserName created"
    }
}

$SqlConnection.Close()
