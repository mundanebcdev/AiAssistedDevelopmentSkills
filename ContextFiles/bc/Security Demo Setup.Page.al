namespace GlobalMediator.bc;

page 50102 "Security Demo Setup"
{
    ApplicationArea = All;
    Caption = 'Security Demo Setup';
    PageType = Card;
    SourceTable = "Security Demo Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Primary Key"; Rec."Primary Key")
                {
                    Editable = false;
                }
                field("Service URL"; Rec."Service URL") { }
                field("API Key"; Rec."API Key") { }
                field("Access Token"; Rec."Access Token") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Allow Export Override"; Rec."Allow Export Override") { }
                field("Last Exported At"; Rec."Last Exported At")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SeedDemoData)
            {
                Caption = 'Seed Demo Data';
                Image = Setup;
                // DEMO NOTE: This action intentionally creates unsafe setup values so the review findings are easy to show.
                ToolTip = 'Seeds intentionally insecure setup values for the security review demo.';

                trigger OnAction()
                var
                    DemoMgt: Codeunit "Security Demo Mgt";
                begin
                    DemoMgt.SeedDemoData();
                    CurrPage.Update(false);
                end;
            }
            action(RunVulnerableFlow)
            {
                Caption = 'Run Vulnerable Flow';
                Image = Start;
                // DEMO NOTE: This action touches the intentionally vulnerable code paths in the management codeunit.
                ToolTip = 'Runs the intentionally insecure integration flow used by the review demo.';
                trigger OnAction()
                var
                    DemoMgt: Codeunit "Security Demo Mgt";
                begin
                    DemoMgt.RunVulnerableFlow();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureDemoRecord();
    end;

    local procedure EnsureDemoRecord()
    begin
        if Rec.Get('DEMO') then
            exit;

        Rec.Init();
        Rec."Primary Key" := 'DEMO';
        Rec.Insert();
    end;
}