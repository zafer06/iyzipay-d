module iyzipay.request;

import std.net.curl: HTTP;
import std.json: JSONValue, parseJSON;

public import iyzipay.iyzipayresource;
public import iyzipay.pkibuilder;

alias GET = HTTP.Method.get;
alias POST = HTTP.Method.post;

class ApiTest : IyzipayResource
{
    public string retrieve(Options options)
    {
        return connectHTTP(GET, options.baseUrl ~ "/payment/test", options);
    }
}

class BinNumber : IyzipayResource
{
    public string retrieve(string request, Options options)
    {
        string pki = toPkiString(request);
        return connectHTTP(POST, options.baseUrl ~ "/payment/bin/check", options, request, pki);
    }

    private string toPkiString(string request)
    {
        JSONValue json = parseJSON(request);

        PkiBuilder pki = new PkiBuilder();
        pki.append("locale", json["locale"].str);
        pki.append("conversationId", json["conversationId"].str);
        pki.append("binNumber", json["binNumber"].str);
        return pki.getPkiString;
    }
}

class InstallmentInfo : IyzipayResource
{
    public string retrieve(string request, Options options)
    {
        string pki = toPkiString(request);
        return connectHTTP(POST, options.baseUrl ~ "/payment/iyzipos/installment", options, request, pki);
    }

    private string toPkiString(string request)
    {
        JSONValue json = parseJSON(request);

        PkiBuilder pki = new PkiBuilder();
        pki.append("locale", json["locale"].str);
        pki.append("conversationId", json["conversationId"].str);
        pki.append("binNumber", json["binNumber"].str);
        pki.append("price", json["price"].str);
        return pki.getPkiString;
    }
}

class Payment : IyzipayResource
{
    public string create(string request, Options options)
    {
        string pki = toPkiString(request);
        return connectHTTP(POST, options.baseUrl ~ "/payment/auth", options, request, pki);
    }

    private string toPkiString(string request)
    {
        JSONValue json = parseJSON(request);

        PkiBuilder pki = new PkiBuilder();
        pki.append("locale", json["locale"].str);
        pki.append("conversationId", json["conversationId"].str);
        pki.append("price", json["price"].str);
        pki.append("paidPrice", json["paidPrice"].str);
        pki.append("installment", json["installment"].str);
        pki.append("paymentChannel", json["paymentChannel"].str);
        pki.append("basketId", json["basketId"].str);
        pki.append("paymentGroup", json["paymentGroup"].str);
        pki.append("paymentCard", pkiPaymentCard(json["paymentCard"]));
        pki.append("buyer", pkiBuyer(json["buyer"]));
        pki.append("shippingAddress", pkiAddress(json["shippingAddress"]));
        pki.append("billingAddress", pkiAddress(json["billingAddress"]));
        pki.append("basketItems", pkiBasketItems(json["basketItems"].array()));
        pki.append("currency", json["currency"].str);
        return pki.getPkiString;
    }

    private string pkiBasketItems(JSONValue[] jsonArray)
    {
        string bastketItems;
        foreach (JSONValue item; jsonArray)
        {
            PkiBuilder pki = new PkiBuilder();
            pki.append("id", item["id"].str);
            pki.append("price", item["price"].str);
            pki.append("name", item["name"].str);
            pki.append("category1", item["category1"].str);
            pki.append("category2", item["category2"].str);
            pki.append("itemType", item["itemType"].str);
            bastketItems ~= pki.getPkiString ~ ", ";
        }
        return "[" ~ bastketItems[0..$-2] ~ "]";
    }

    private string pkiAddress(JSONValue json)
    {
        PkiBuilder pki = new PkiBuilder();
        pki.append("address", json["address"].str);
        pki.append("zipCode", json["zipCode"].str);
        pki.append("contactName", json["contactName"].str);
        pki.append("city", json["city"].str);
        pki.append("country", json["country"].str);
        return pki.getPkiString;
    }

    private string pkiBuyer(JSONValue json)
    {
        PkiBuilder pki = new PkiBuilder();
        pki.append("id", json["id"].str);
        pki.append("name", json["name"].str);
        pki.append("surname", json["surname"].str);
        pki.append("identityNumber", json["identityNumber"].str);
        pki.append("email", json["email"].str);
        pki.append("gsmNumber", json["gsmNumber"].str);
        pki.append("registrationDate", json["registrationDate"].str);
        pki.append("lastLoginDate", json["lastLoginDate"].str);
        pki.append("registrationAddress", json["registrationAddress"].str);
        pki.append("city", json["city"].str);
        pki.append("country", json["country"].str);
        pki.append("zipCode", json["zipCode"].str);
        pki.append("ip", json["ip"].str);
        return pki.getPkiString;
    }

    private string pkiPaymentCard(JSONValue json)
    {
        PkiBuilder pki = new PkiBuilder();
        pki.append("cardHolderName", json["cardHolderName"].str);
        pki.append("cardNumber", json["cardNumber"].str);
        pki.append("expireYear", json["expireYear"].str);
        pki.append("expireMonth", json["expireMonth"].str);
        pki.append("cvc", json["cvc"].str);
        pki.appendPrice("registerCard", json["registerCard"].integer);
        return pki.getPkiString;
    }
}
