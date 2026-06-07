$BasePath = "F:\DFSRoots\Isiklik"
$Domain = "slillep"

Get-ADUser -Filter * -SearchBase "OU=Kasutajad,DC=slillep,DC=local" | ForEach-Object {
    $UserFolder = Join-Path $BasePath $_.SamAccountName

    if (!(Test-Path $UserFolder)) {
        New-Item -Path $UserFolder -ItemType Directory
    }

    $Acl = Get-Acl $UserFolder
    $Acl.SetAccessRuleProtection($true, $false)

    $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "$Domain\Domain Admins",
        "FullControl",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )

    $UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "$Domain\$($_.SamAccountName)",
        "Modify",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )

    $Acl.Access | ForEach-Object {
        $Acl.RemoveAccessRule($_)
    }

    $Acl.AddAccessRule($AdminRule)
    $Acl.AddAccessRule($UserRule)

    Set-Acl -Path $UserFolder -AclObject $Acl
}
