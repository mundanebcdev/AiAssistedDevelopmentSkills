namespace GlobalMediator.bc;

using Microsoft.Sales.Customer;

table 50100 "Security Demo Setup"
{
    Caption = 'Security Demo Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Service URL"; Text[250])
        {
            Caption = 'Service URL';
            DataClassification = CustomerContent;
        }
        field(3; "API Key"; Text[250])
        {
            Caption = 'API Key';
            ExtendedDatatype = Masked;
        }
        field(4; "Access Token"; Text[2048])
        {
            Caption = 'Access Token';
            DataClassification = ToBeClassified;
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            ValidateTableRelation = false;
        }
        field(6; "Last Exported At"; DateTime)
        {
            Caption = 'Last Exported At';
            DataClassification = SystemMetadata;
        }
        field(7; "Allow Export Override"; Boolean)
        {
            Caption = 'Allow Export Override';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}