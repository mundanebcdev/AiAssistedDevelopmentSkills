namespace GlobalMediator.bc;

table 50105 "Security Demo Export Buffer"
{
    Caption = 'Security Demo Export Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(3; Payload; Text[2048])
        {
            Caption = 'Payload';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}