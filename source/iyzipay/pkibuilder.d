module iyzipay.pkibuilder;

import std.algorithm.mutation: strip;
import std.string: indexOf;
import std.format: format;
import std.conv: to;

class PkiBuilder
{
    private string _pkiString;

    public void append(string key, string value)
    {
        _pkiString = _pkiString ~ key ~ "=" ~ value ~ ",";
    }
    unittest
    {
        PkiBuilder pki = new PkiBuilder();
        pki.append("key", "value");

        assert(pki.getPkiString == "[key=value]", pki.getPkiString);
    }

    public void appendPrice(string key, string value)
    {
        string formatPrice = value.indexOf('.') < 0 ? value ~ ".0" : value.strip('0');
        _pkiString = _pkiString ~ key ~ "=" ~ formatPrice ~ ",";
    }
    unittest
    {
        PkiBuilder pki = new PkiBuilder();
        pki.appendPrice("price3", "100");
        pki.appendPrice("price4", "100.10");
        pki.appendPrice("price5", "100.123");
        pki.appendPrice("price6", "100.10100");
        pki.appendPrice("price7", "100.120");

        assert(pki.getPkiString == "[price3=100.0,price4=100.1,price5=100.123,price6=100.101,price7=100.12]",
                pki.getPkiString);
    }

    public void appendArray(string key, string value)
    {
        _pkiString = _pkiString ~ key ~ "=" ~ value ~ ",";
    }

    private void removeTrailingComma()
    {
        _pkiString = _pkiString[0..$-1];
    }

    public string getPkiString() @property
    {
        removeTrailingComma();
        return "[" ~ _pkiString ~ "]";
    }
}
