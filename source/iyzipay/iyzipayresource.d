module iyzipay.iyzipayresource;

import std.stdio: writefln;
import std.string: indexOf, format;
import std.array: appender;
import std.net.curl: HTTP;
import std.datetime: Clock;
import std.digest: toHexString;
import std.digest.sha: sha1Of;
import std.base64: Base64;
import std.experimental.logger;

enum VERSION = "0.6.3";
enum AUTHORIZATION = "Authorization";
enum RANDOM_HEADER_NAME = "x-iyzi-rnd";
enum CLIENT_VERSION = "x-iyzi-client-version";
enum IYZIWS_HEADER_NAME = "IYZWS ";
enum COLON = ":";

struct Options
{
    string apiKey;
    string secretKey;
    string baseUrl;
}

class IyzipayResource
{
    public string connectHTTP(HTTP.Method method, string url, Options options, string request = "", string pkiString = "")
    {
    	string[string] headers = getHttpHeaders(pkiString, options);

        writefln("--> %s", pkiString);

        auto receivedData = appender!string();
    	HTTP client = HTTP(url);	// Connect API via HTTP
    	client.method = method;
    	//client.addRequestHeader("Content-Type", headers["Content-Type"]);
    	client.addRequestHeader("x-iyzi-rnd", headers["x-iyzi-rnd"]);
    	client.addRequestHeader("x-iyzi-client-version", headers["x-iyzi-client-version"]);
    	client.addRequestHeader("Authorization", headers["Authorization"]);
    	if (method == HTTP.Method.post) client.setPostData(request, "application/json");
    	client.onReceive = delegate size_t(ubyte[] data) { receivedData.put(data); return data.length; };
    	client.perform();

    	return receivedData.data;
    }

    private string[string] getHttpHeaders(string pkiString, Options options)
    {
        string randomString = Clock.currTime().toISOExtString();

        string[string] headers;
        headers["Content-Type"] = "application/json";
        headers[RANDOM_HEADER_NAME] = randomString;
        headers[CLIENT_VERSION] = "iyzipay-d-" ~ VERSION;
        headers[AUTHORIZATION] = prepareAuthorizationString(pkiString, randomString, options);
        return headers;
    }

    private string prepareAuthorizationString(string pkiString, string randomString, Options options)
    {
        string hash = Base64.encode(sha1Of(options.apiKey ~ randomString ~ options.secretKey ~ pkiString));

        //_logger.log("[PKI String] ", pkiString);
        //_logger.log("[Authorization String] ", IYZIWS_HEADER_NAME ~ options.apiKey ~ COLON ~ hash);

        return IYZIWS_HEADER_NAME ~ options.apiKey ~ COLON ~ hash;
    }
}
