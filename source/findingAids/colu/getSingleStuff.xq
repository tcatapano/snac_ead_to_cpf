xquery version "1.0";



declare namespace f="urn:my-functions";
declare namespace xpath="http://www.w3.org/2005/xpath-functions";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace ead="urn:isbn:1-931666-22-9";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare variable $section as xs:string  := request:get-parameter("section", '');

declare variable $level1  := xs:integer(request:get-parameter("level1", ())) ;
declare variable $level2  := xs:integer(request:get-parameter("level2", ())) ;
 

declare variable $filepath as xs:string  := xpath:concat("/db/ead/nnc-rb/", request:get-parameter("doc", '')) ;

declare option exist:serialize "method=xml media-type=text/xml encoding=utf-8 indent=yes ";

(:
bout_collection
about_findingaid
using_collection
prefercite

:)

(: no section specified :)

if ($section eq '')

then
   for $x in doc($filepath)/ead:ead
   return $x
   
   else (),

(: toc calls stylesheet to returns c hierarchy with only did elements and c's whose level does not equal "file" :)
if ($section eq 'toc')

then
let $doc := doc($filepath)/*
  
 return <result>{transform:transform($doc, xmldb:document("/db/ead/nnc-rb/styles/getSecs.xsl"), <parameters><param name="template" value="toc"/></parameters>)}</result>
   (: for $x in doc($filepath)/ead:ead/ead:archdesc/ead:dsc//ead:c
   return $x/ead:c/ead:did
   :) 
else (),

(: collection level did :)
if ($section eq 'hi-did')

then
let $doc := doc($filepath)/*
  
   (:  return transform:transform($doc, "ead/nnc-rb/styles/getSecs.xsl", <parameters><param name="template" value="hi-did"/></parameters>) :)
   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:did
   return $x
   
else (),




(: eadheader :)
if ($section eq 'header')

then

   for $x in doc($filepath)/ead:ead
   return $x/ead:eadheader
   
else (),

(: dsc :)

if ($section eq 'dsc')


then

(: if there's a level2 return the hierarchy starting for the c at the position provided :)

if ($level2 != 0)

      then

        for $x in doc($filepath)/ead:ead
        let $c := $x//ead:dsc/ead:c[position() = $level1]/ead:c[position() = $level2]
        let $p := $x//ead:dsc/ead:c[position() = $level1]/ead:did/ead:unittitle//text()
        return <result><parent_heading>{$p}</parent_heading>{$c}</result>

else 


(: else if there's a level1 return all c's at that level :)

if ($level1 != 0)
then
   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:dsc
   let $c := $x/ead:c[xpath:position() = $level1]
   return <result>{$c}</result>
else

(: just return the entire dsc :)


for $x in doc($filepath)/ead:ead/ead:archdesc/ead:dsc
   let $c := $x/ead:c
   return <result>{$c}</result>
else (),

(: prefercite :)
if ($section eq 'prefercite')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:prefercite
   return $x
   
else (),

(: using_collection :)
if ($section eq 'using_collection')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:accessrestrict}{$x/ead:userestrict}{$x/ead:acquinfo}{$x/ead:accruals}{$x/ead:prefercite}{$x/ead:otherfindaid}{$x/ead:relatedmaterial}</result>
   
else (),

(: summary :)
if ($section eq 'summary')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:did
   let $y := doc($filepath)/ead:ead/ead:archdesc/ead:accessrestrict/ead:p
   return <result>{$x/ead:unittitle}{$x/ead:unitdate}{$x/ead:origination}{$x/ead:unitid}{$x/ead:physdesc}{$x/ead:langmaterial}{$x/ead:abstract}<accessrestrict>{$y}</accessrestrict></result>
   
else (),

(: history :)
if ($section eq 'history')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:bioghist}</result>
   
else (),

(: about_findaid :)
if ($section eq 'about_findaid')

then

   for $x in doc($filepath)/ead:ead
   return <result>{$x/ead:eadheader/ead:filedesc/ead:titlestmt/ead:author}{$x/ead:eadheader/ead:filedesc/ead:publicationstmt}{$x/ead:archdesc/ead:processinfo}{$x/ead:eadheader/ead:profiledesc}{$x/ead:eadheader/ead:revisiondesc}{$x/ead:archdesc/ead:descrules}</result>
   
else (),

(: subjects :)
if ($section eq 'subjects')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:controlaccess}</result>
   
else (),

(: title :)
if ($section eq 'title')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:did
   return <result>{$x/ead:unittitle}{$x/ead:unitdate}</result>
   
else (),

(: dsc_sc :)
if ($section eq 'dsc_sc')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc/ead:dsc
   let $count1 := xpath:count($x/ead:c)
   let $count2 := xpath:count($x/ead:c/ead:c)
   let $count3 := xpath:count($x/ead:c/ead:c/ead:c)
   return <result>
   { for $c1 in $x/ead:c[@level = 'series'][child::ead:scopecontent]
   let $position := xpath:count($c1/preceding-sibling::ead:c) + 1 
   return <series level1="{$position}">{$c1/ead:did/ead:unittitle}{$c1/ead:scopecontent}
                  <children>
                    {for $c2 in $c1/ead:c[@level = 'subseries'][child::ead:scopecontent]
                    
                    let $position2 := xpath:count($c2/preceding-sibling::ead:c) + 1 
                      return
                      <child level1="{$position}" level2="{$position2}">{$c2/ead:did/ead:unittitle}{$c2/ead:scopecontent}
                      </child>
                   }
                   </children>
           </series>                  
}
</result>
else (),



(: access :)
if ($section eq 'access')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:accessrestrict}</result>
   
else (),

(: relatedmaterial :)
if ($section eq 'related')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:relatedmaterial}</result>
   
else (),


(: scope_content :)
if ($section eq 'scope_content')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:scopecontent}</result>
   
else (),

(: arrangement :)
if ($section eq 'arrangement')

then

   for $x in doc($filepath)/ead:ead/ead:archdesc
   return <result>{$x/ead:arrangement}</result>
   
else (),
(: dublin core in RDF/XML for Finding Aid :)
if ($section eq 'dc')

then

   for $x in doc($filepath)/ead:ead
   return <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xml:base="http://ldpd.lampdev.columbia.edu/fa/ead/nnc-rb/{request:get-parameter("doc", '')}" xmlns:dc="http://dublincore.org/2008/01/14/dcterms.rdf#">   {
      for $y in $x/ead:eadheader//*[@encodinganalog]
        return element  {QName("http://dublincore.org/2008/01/14/dcterms.rdf#", concat("dc:", $y/@encodinganalog ))}
         {$y/text()}
       
       }
       
       {
       for $s in $x//ead:controlaccess/*
       return <dc:subject>{$s/text()}</dc:subject> 
        }
        {
        for $o in $x/ead:archdesc/ead:did/ead:origination
         return <dc:subject>{$o//text()}</dc:subject>
        }
        <dc:format>text/xml</dc:format>
        <dc:type>Text</dc:type>
        <dc:type>Internet Resource</dc:type>
        </rdf:RDF>
else (),

if ($section eq 'coins')

then
let $doc := doc($filepath)/*
return element span {
attribute class {"Z3988"},
attribute title { transform:transform($doc, xmldb:document("/db/ead/nnc-rb/styles/getCoins.xsl"), <parameters><param name="template" value="hi-did"/></parameters>) }, "COinS Metadata"
}
      
else (),
(: events :)
if ($section eq 'events')

then
let $doc := doc($filepath)/*
return <data>{transform:transform($doc, xmldb:document("/db/ead/nnc-rb/styles/events.xsl"), <parameters></parameters>) }</data>
else (),

(: exhibit_tl :)
if ($section eq 'exhibit_tl')


then
let $doc := doc($filepath)/*
return transform:transform($doc, xmldb:document("/db/ead/nnc-rb/styles/exhibit_tl.xsl"), <parameters><param name="doc" value="{request:get-parameter("doc", '')}"/></parameters>)
else ()