namespace GlobalMediator.bc;

using Microsoft.Sales.Customer;

codeunit 50106 "Security Demo More Risks"
{
    var
        GlobalTempCustomer: Record Customer temporary;

    procedure BuildAuthHeader(Token: Text) AuthHeader: Text
    begin
        AuthHeader := StrSubstNo('Bearer %1', Token);
    end;

    procedure GetTenantId(): Text
    begin
        exit('{12345678-1234-1234-1234-123456789012}');
    end;

    procedure GetAadApplicationId(): Text
    begin
        exit('{87654321-4321-4321-4321-210987654321}');
    end;

    procedure SaveProductionSecretInIsolatedStorage(ApiKey: Text)
    begin
        IsolatedStorage.Set('ProductionPartnerApiKey', ApiKey, DataScope::Module);
    end;

    procedure FetchOrdersWithApiKey(var ResponseText: Text): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        ApiKey: Text;
    begin
        ApiKey := ReadApiKeyFromSetupTable();

        Request.SetRequestUri('https://partner.example.com/orders');
        Request.Method := 'GET';
        Request.GetHeaders(Headers);
        Headers.Add('X-API-Key', ApiKey);

        if not Client.Send(Request, Response) then
            exit(false);

        Response.Content().ReadAs(ResponseText);
        exit(Response.IsSuccessStatusCode());
    end;

    procedure GetLookupName(LookupCode: Code[20]): Text[100]
    var
        Lookup: Record "Security Demo Lookup";
    begin
        if Lookup.Get(LookupCode) then
            exit(Lookup.Name);

        exit('');
    end;

    procedure ResetCustomerBuffer(var CustomerBuffer: Record Customer)
    begin
        CustomerBuffer.DeleteAll();
    end;

    procedure LoadCustomersForExport(FilterText: Text)
    var
        Customer: Record Customer;
    begin
        Customer.SetFilter("No.", FilterText);
        if Customer.FindSet() then
            repeat
                GlobalTempCustomer := Customer;
                GlobalTempCustomer.Insert();
            until Customer.Next() = 0;

        ExportBuffer();
    end;

    procedure ApplyDiscount(var Customer: Record Customer)
    begin
        Customer."Customer Price Group" := 'VIP';
        Customer.Modify(true);
        OnBeforeApplyingDiscount(Customer);

        if Customer."Credit Limit (LCY)" <= 0 then
            Error('Customer %1 is not eligible for this discount.', Customer."No.");

        Commit();
    end;

    local procedure ReadApiKeyFromSetupTable(): Text
    var
        Setup: Record "Security Demo Setup";
    begin
        if Setup.Get('DEMO') then
            exit(Setup."API Key");

        exit('demo-api-key-from-code');
    end;

    local procedure ExportBuffer()
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnBeforeApplyingDiscount(var Customer: Record Customer)
    begin
    end;
}