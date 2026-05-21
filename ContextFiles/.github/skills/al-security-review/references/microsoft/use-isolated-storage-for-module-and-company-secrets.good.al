codeunit 50208 "Sec Sample IsolatedStorage Good"
{
    internal procedure StoreApiKey(NewKey: SecretText)
    begin
        IsolatedStorage.SetEncrypted('ApiKey', NewKey, DataScope::Module);
    end;

    local procedure TryGetApiKey(var ApiKey: SecretText): Boolean
    begin
        if IsolatedStorage.Contains('ApiKey', DataScope::Module) then
            exit(IsolatedStorage.Get('ApiKey', DataScope::Module, ApiKey));
        exit(false);
    end;
}
