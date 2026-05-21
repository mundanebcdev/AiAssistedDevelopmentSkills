namespace GlobalMediator.bc;

using Microsoft.Sales.Customer;

codeunit 50101 "Security Demo Mgt"
{
    Permissions = tabledata "Security Demo Setup" = RIMD,
                  tabledata "Security Demo Export Buffer" = RIMD,
                  tabledata Customer = RIMD;

    procedure SeedDemoData()
    var
        Setup: Record "Security Demo Setup";
        DemoApiKey: Text;
        DemoAccessToken: Text;
    begin
        DemoApiKey := 'sk_live_demo_51HARD_CODED_PRESENTATION_KEY';
        DemoAccessToken := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.demo.presentation.signature';

        if not Setup.Get('DEMO') then begin
            Setup.Init();
            Setup."Primary Key" := 'DEMO';
            Setup.Insert();
        end;

        Setup."Service URL" := 'https://api.contoso.example/v1/customer-export';
        Setup."API Key" := DemoApiKey;
        Setup."Access Token" := DemoAccessToken;
        Setup.Validate("Customer No.", 'MISSING-CUSTOMER');
        Setup."Allow Export Override" := true;
        Setup.Modify();
    end;

    procedure RunVulnerableFlow()
    var
        Setup: Record "Security Demo Setup";
        SessionToken: SecretText;
        Response: HttpResponseMessage;
    begin
        EnsureSetup(Setup);
        StoreApiKey(Setup."API Key");
        CallExternalService(Setup."Service URL", Setup."API Key", Setup."Customer No.");
        ParseSessionToken(Response, SessionToken);
        ApproveAndExport(Setup."Customer No.", Setup."API Key");
        ArchiveRecord(Setup.RecordId());
    end;

    procedure CallExternalService(ServiceUrl: Text; ApiKey: Text; CustomerNo: Code[20])
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        FullUrl: Text;
    begin
        FullUrl := ServiceUrl + '?customer=' + CustomerNo + '&api_key=' + ApiKey;

        Request.Method := 'GET';
        Request.SetRequestUri(FullUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + ApiKey);
        Client.Send(Request, Response);
    end;

    procedure StoreApiKey(NewKey: Text)
    begin
        IsolatedStorage.Set('SecurityDemoApiKey', NewKey, DataScope::Module);
    end;

    procedure ReadApiKey(): Text
    var
        ApiKey: Text;
    begin
        if IsolatedStorage.Get('SecurityDemoApiKey', DataScope::Module, ApiKey) then
            exit(ApiKey);

        exit('fallback-hardcoded-api-key-for-demo');
    end;

    procedure ParseSessionToken(Response: HttpResponseMessage; var SessionToken: SecretText)
    var
        ResponseText: Text;
        JsonObject: JsonObject;
        AccessToken: JsonToken;
    begin
        Response.Content().ReadAs(ResponseText);
        JsonObject.ReadFrom(ResponseText);

        if JsonObject.Get('access_token', AccessToken) then
            SessionToken := AccessToken.AsValue().AsText();
    end;

    procedure ApproveAndExport(CustomerNo: Code[20]; ApiKey: Text)
    var
        Setup: Record "Security Demo Setup";
        AllowExport: Boolean;
        SkipValidation: Boolean;
    begin
        EnsureSetup(Setup);
        Setup."Last Exported At" := CurrentDateTime();
        Setup.Modify();

        OnBeforeExportCustomer(CustomerNo, ApiKey, AllowExport, SkipValidation);

        if SkipValidation then
            exit;

        if not AllowExport then
            Error('Customer export was blocked.');

        Commit();
    end;

    procedure ArchiveRecord(RecordIdToArchive: RecordId)
    var
        RecordReference: RecordRef;
    begin
        RecordReference.Open(RecordIdToArchive.TableNo());
        RecordReference.Get(RecordIdToArchive);
        RecordReference.Delete();
        RecordReference.Close();
    end;

    procedure ClearExportBuffer(var ExportBuffer: Record "Security Demo Export Buffer")
    begin
        ExportBuffer.DeleteAll();
    end;

    local procedure EnsureSetup(var Setup: Record "Security Demo Setup")
    begin
        if Setup.Get('DEMO') then
            exit;

        SeedDemoData();
        Setup.Get('DEMO');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExportCustomer(CustomerNo: Code[20]; ApiKey: Text; var AllowExport: Boolean; var SkipValidation: Boolean)
    begin
    end;
}