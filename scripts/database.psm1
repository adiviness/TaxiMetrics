
# change these to match the database settings for your use case
$SqlServer = "taxi-metrics-adiviness.database.windows.net"
$SqlDatabase = "taxi-metrics-db"


#.SYNOPSIS
# connects to database and executes a sql file.
#
#.PARAMETER Username
# user name to use to connect to database
#
#.PARAMETER Password
# password to use to connect to database
#
#.PARAMETER File
# sql file to execute
function Invoke-DatabaseFile()
{
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true)]
        [string]$Username,

        [parameter(Mandatory=$true)]
        [string]$Password,

        [parameter(Mandatory=$true)]
        [string]$File
    )

    $Query = Get-Content $File -Raw

    # connect and run query
    $Connection = New-Object System.Data.SqlClient.SqlConnection
    $Connection.ConnectionString = "Server = $SqlServer; Database = $SqlDatabase; Integrated Security = False; User ID = $Username; Password = $Password;"

    $Command = New-Object System.Data.SqlClient.SqlCommand
    $Command.CommandText = $Query
    $Command.Connection = $Connection

    $Adapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $Adapter.SelectCommand = $Command

    $DataSet = New-Object System.Data.DataSet
    $Adapter.Fill($DataSet)

    # print data
    $DataSet.Tables[0] | format-table
}

#.SYNOPSIS
# Populates tables in database with csv data
#
#.PARAMETER Username
# user name to use to connect to database
#
#.PARAMETER Password
# password to use to connect to database
#
#.PARAMETER DataPath
# path to directory that contains csv data files
function Invoke-PopulateDatabase()
{
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true)]
        [string]$Username,

        [parameter(Mandatory=$true)]
        [string]$Password,

        [parameter(Mandatory=$true)]
        [string]$DataPath
    )

    # make sure that bcp is in path
    if ((Get-Command "bcp" -ErrorAction SilentlyContinue) -eq $null)
    {
        Write-Error "bcp not found in path!"
        return
    }
    $ZoneFile = "taxi_zone_lookup.csv"
    $ForHireFile = "fhv_tripdata_2018-01.csv"
    $YellowFile = "yellow_tripdata_2018-01.csv"
    $GreenFile = "green_tripdata_2018-01.csv"

    foreach ($file in @($ZoneFile, $ForeHireFile, $YellowFile, $GreenFile))
    {
        # make sure that data directory contains correct data files
        if (!(Test-Path "$DataPath/$file"))
        {
            Write-Error "$file not found!"
            return
        }
    }
    # bulk insert data files into respective tables
    # Commentary: It bothers me slightly that these lines are so similar, if I had more
    # time I would condense them into the loop above.
    Start-Process bcp "Zones in $DataPath/$ZoneFile -S $SqlServer -d $SqlDatabase -U $Username -P $Password -q -c -t , -h TABLOCK" -Wait -NoNewWindow
    Start-Process bcp "GreenCab in $DataPath/$GreenFile -S $SqlServer -d $SqlDatabase -U $Username -P $Password -q -c -t , -h TABLOCK" -Wait -NoNewWindow
    Start-Process bcp "ForHire in $DataPath/$ForHireFile -S $SqlServer -d $SqlDatabase -U $Username -P $Password -q -c -t , -h TABLOCK" -Wait -NoNewWindow
    Start-Process bcp "YellowCab in $DataPath/$YellowFile -S $SqlServer -d $SqlDatabase -U $Username -P $Password -q -c -t , -h TABLOCK" -Wait -NoNewWindow
}

Export-ModuleMember -Function Invoke-DatabaseFile,Invoke-PopulateDatabase
