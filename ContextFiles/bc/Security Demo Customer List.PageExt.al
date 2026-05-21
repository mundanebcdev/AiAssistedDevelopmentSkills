namespace GlobalMediator.bc;

using Microsoft.Sales.Customer;

pageextension 50104 "Security Demo Customer List" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action(OpenSecurityReviewDemo)
            {
                ApplicationArea = All;
                Caption = 'Security Review Demo';
                Image = Security;
                RunObject = page "Security Demo Setup";
                ToolTip = 'Opens the intentionally insecure setup used by the security review demo.';
            }
        }
    }
}