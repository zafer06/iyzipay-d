import std.stdio;
import std.json;
import std.string;
import std.process;

import iyzipay.requests;

void main()
{
	Options options;
    options.apiKey = environment["API_KEY"],
    options.secretKey = environment["SECRET_KEY"],
    options.baseUrl = "https://sandbox-api.iyzipay.com";

	apiTest(options);
	binNumber(options);
	installmentInfo(options);
	//createPayment(options);
	//retrievePayment(options);
    //createThreedsInitialize(options);
    //createThreedsPayment(options);
    //createCancel(options);
    //createRefund(options);
    //createCard(options);
    //deleteCard(options);
    //retrieveCards(options);
}

void retrieveCards(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "cardUserKey": "card user key"
    }`;

    CardList card = new CardList();
    string result = card.retrieve(request, options);

	writeResult("Cards Retrieve", result);
}

void deleteCard(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "cardToken": "card token",
        "cardUserKey": "card user key"
    }`;

    Card card = new Card();
    string result = card.delete_(request, options);

	writeResult("Card Delete", result);
}

void createCard(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "externalId": "external id",
        "email": "email@email.com",
        "cardUserKey": "userkey",
        "card": {
            "cardAlias": "card alias",
            "cardHolderName": "John Doe",
            "cardNumber": "5528790000000008",
            "expireMonth": "12",
            "expireYear": "2030"
        }
    }`;

    Card card = new Card();
    string result = card.create(request, options);

	writeResult("Card Create", result);
}

void createRefund(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "paymentTransactionId": "11188574",
        "price": "2.17",
        "currency": "TRY",
        "ip": "84.34.78.112"
    }`;

    Refund refund = new Refund();
    string result = refund.create(request, options);

	writeResult("Refund", result);
}

void createCancel(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "paymentId": "10639181",
        "ip": "84.34.78.112"
    }`;

    Cancel cancel = new Cancel();
    string result = cancel.create(request, options);

	writeResult("Cancel", result);
}

void createThreedsPayment(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "paymentId": "10639182",
        "conversationData": ""
    }`;

    ThreedsPayment threeds = new ThreedsPayment();
    string result = threeds.create(request, options);

	writeResult("ThreeDS Payment", result);
}

void createThreedsInitialize(Options options)
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
        "currency": "TRY",
        "callbackUrl": "http://95.9.88.93:91/3dpage.php"
    }`;

    ThreedsInitialize threeds = new ThreedsInitialize();
    string result = threeds.create(request, options);

	writeResult("3D Initialize", result);
}

void retrievePayment(Options options)
{
    string request = `{
        "locale": "tr",
        "conversationId": "123456789",
        "paymentId": "10631024",
        "paymentConversationId": "123456789"
    }`;

	Payment payment = new Payment();
	string result = payment.retrieve(request, options);

	writeResult("Retrieve Payment", result);
}

void createPayment(Options options)
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

	writeResult("Create Payment", result);
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
		writefln("--> %s: %s -- errorCode: %s -- errorMessage: %s",
			description, json["status"].str, json["errorCode"].str, json["errorMessage"].str);
	}
}
