namespace GlobalMediator.bc;

using Microsoft.Sales.Customer;

permissionset 50108 "SEC DEMO WRITE"
{
    Assignable = true;
    Caption = 'Security Demo Direct Write';
    Permissions =
        tabledata Customer = RM,
        tabledata "Security Demo Lookup" = R;
}

permissionset 50109 "SEC DEMO ORDER ENTRY"
{
    Assignable = true;
    Caption = 'Security Demo Order Entry';
    Permissions =
        tabledata Customer = RIM,
        tabledata "Security Demo Setup" = RIM;
}

permissionset 50110 "SEC DEMO ORDER VIEW"
{
    Assignable = true;
    Caption = 'Security Demo Order View';
    Permissions =
        tabledata Customer = R,
        tabledata "Security Demo Setup" = R;
}