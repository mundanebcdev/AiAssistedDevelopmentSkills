codeunit 50241 "Sec Sample Url Bad"
{
    procedure Sync(ServiceUrl: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
    begin
        Client.Get(ServiceUrl, Response);
    end;
}
