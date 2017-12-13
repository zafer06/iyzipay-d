import std.stdio;
import std.json;
import std.string;

import iyzipay.request;

void main()
{
	Options options;
	options.apiKey = "your api key";
	options.secretKey = "your api key";
	options.baseUrl = "https://sandbox-api.iyzipay.com";

	apiTest(options);
	binNumber(options);
	installmentInfo(options);
	payment(options);
}

void payment(Options options)
{
	string request = `{
		"locale": "tr",
		"conversationId": "123456789",
		"price": "6.0",
		"paidPrice": "6.5",
		"installment": "1",
		"paymentChannel": "WEB",
		"basketId": "B67832",
		"paymentGroup": "PRODUCT",
        "paymentCard": {
	        "cardHolderName": "John Doe",
	        "cardNumber": "5528790000000008",
	        "expireYear": "2030",
	        "expireMonth": "12",
	        "cvc": "123",
	        "registerCard": 0
	    },
        "buyer": {
    		"id": "BY789",
    		"name": "John",
    		"surname": "Doe",
    		"identityNumber": "74300864791",
    		"email": "email@email.com",
    		"gsmNumber": "+905350000000",
    		"registrationDate": "2013-04-21 15:12:09",
    		"lastLoginDate": "2015-10-05 12:43:35",
    		"registrationAddress": "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
    		"city": "Istanbul",
    		"country": "Turkey",
    		"zipCode": "34732",
    		"ip": "85.34.78.112"
        },
        "shippingAddress": {
    		"address": "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
    		"zipCode": "34742",
    		"contactName": "Jane Doe",
    		"city": "Istanbul",
    		"country": "Turkey"
        },
        "billingAddress": {
    		"address": "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            "zipCode": "34742",
    		"contactName": "Jane Doe",
    		"city": "Istanbul",
    		"country": "Turkey"
    	},
        "basketItems": [
    		{
    			"id": "BI101",
    			"price": "3.0",
    			"name": "Binocular",
    			"category1": "Collectibles",
    			"category2": "Accessories",
    			"itemType": "PHYSICAL"
    		},
    		{
    			"id": "BI102",
    			"price": "2.0",
    			"name": "Game code",
    			"category1": "Game",
    			"category2": "Online Game Items",
    			"itemType": "VIRTUAL"
    		},
    		{
    			"id": "BI103",
    			"price": "1.0",
    			"name": "Usb",
    			"category1": "Electronics",
    			"category2": "Usb / Cable",
    			"itemType": "PHYSICAL"
    		}
    	],
        "currency": "TRY"
    }`;

	Payment payment = new Payment();
	string result = payment.create(request, options);

	writeResult("Payment", result);
}

void installmentInfo(Options options)
{
	string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "binNumber": "542119",
		"price": "100.0"
    }`;

	InstallmentInfo installment = new InstallmentInfo();
	string result = installment.retrieve(request, options);

	writeResult("Installment Info", result);
}

void binNumber(Options options)
{
	string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "binNumber": "542119"
    }`;

	BinNumber bin = new BinNumber();
	string result = bin.retrieve(request, options);

	writeResult("Bin Number", result);
}

void apiTest(Options options)
{
	ApiTest api = new ApiTest();
	string result = api.retrieve(options);

	writeResult("Api Test", result);
}

void writeResult(string description, string result)
{
	JSONValue json = parseJSON(result);

	if (json["status"].str == "success")
	{
		writefln("--> %s: %s", description, json["status"].str);
	}
	else
	{
		writefln("--> %s: %s -- errorCode: %s -- errorMessage: %s -- errorGroup: %s",
			description, json["status"].str, json["errorCode"].str, json["errorMessage"].str, json["errorGroup"].str);
	}
}
