xquery version "1.0";



declare namespace f="urn:my-functions";
declare namespace xpath="http://www.w3.org/2005/xpath-functions";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink="http://www.w3.org/1999/xlink";

 

declare variable $filepath as xs:string  := xpath:concat("/db/ead/nnc-rb/", request:get-parameter("doc", '')) ;

declare option exist:serialize "method=text media-type=application/json";


let $doc := doc($filepath)/*
return transform:transform($doc, xmldb:document("/db/ead/nnc-rb/styles/exhibit_json.xsl"), <parameters></parameters>)





