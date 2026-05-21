codeunit 50240 "Sec Sample Url Good"
{
    procedure Sync(ServiceUrl: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Uri: Codeunit Uri;
        ExpectedBaseUrl: Text;
    begin
        ExpectedBaseUrl := 'https://api.contoso.com';

        if not Uri.AreURIsHaveSameHost(ServiceUrl, ExpectedBaseUrl) then
            Error('Service URL must point to api.contoso.com.');

        Client.Get(ServiceUrl, Response);
    end;
}
