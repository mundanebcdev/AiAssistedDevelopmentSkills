namespace GlobalMediator.bc;

table 50107 "Security Demo Lookup"
{
    Caption = 'Security Demo Lookup';

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}