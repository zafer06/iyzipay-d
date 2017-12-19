module iyzipay.pkibuilder;

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

        assert(pki.getPkiString == "[key=value]");
    }

    public void appendPrice(string key, long value)
    {
        _pkiString = _pkiString ~ key ~ "=" ~ to!string(value) ~ ",";
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
