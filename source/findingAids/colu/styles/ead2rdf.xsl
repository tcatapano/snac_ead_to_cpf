<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:dcterms="http://purl.org/dc/terms/" version="1.1">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:param name="collection_base-uri">
        <xsl:text>http://www.columbia.edu/cu/lweb/archival/collections/ldpd_</xsl:text>
    </xsl:param>
    <xsl:param name="collection_id">
        <xsl:value-of select="substring-before(substring-after(normalize-space(//ead:ead/ead:eadheader/ead:eadid), '_'), '_')"/>
    </xsl:param>
    <xsl:template match="/">
        <rdf:RDF><xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="ead:ead">
        <rdf:Description rdf:about="{$collection_base-uri}{$collection_id}">
            <xsl:apply-templates/>
            <dc:type rdf:resource="http://purl.org/dc/dcmitype/Collection"/>
        </rdf:Description>
        <xsl:for-each select="ead:archdesc/ead:dsc//ead:c">
            <xsl:call-template name="series"/>
        </xsl:for-each>
       <!-- <xsl:for-each select="ead:archdesc/ead:dsc/ead:c/ead:c">
            <xsl:call-template name="series"/>
        </xsl:for-each>
        <xsl:for-each select="ead:archdesc/ead:dsc/ead:c/ead:c/ead:c">
            <xsl:call-template name="series"/>
        </xsl:for-each>
        <xsl:for-each select="ead:archdesc/ead:dsc/ead:c/ead:c/ead:c/ead:c">
            <xsl:call-template name="series"/>
        </xsl:for-each>
        -->
    </xsl:template>
    <xsl:template match="ead:eadheader"> </xsl:template>
    <xsl:template match="ead:archdesc">
        <xsl:apply-templates select="child::ead:did/ead:unittitle | ead:did/ead:origination | ead:did/ead:physdesc | ead:scopecontent | ead:controlaccess | ead:dsc"/>
    </xsl:template>
    <xsl:template match="ead:unittitle">
        <dc:title><xsl:value-of select="normalize-space(.)"/>
        </dc:title>
    </xsl:template>
    <xsl:template match="ead:origination">
        <dc:creator><xsl:value-of select="normalize-space(.)"/>
        </dc:creator>
    </xsl:template>
    <xsl:template match="ead:physdesc">
        <dc:description><xsl:value-of select="normalize-space(.)"/>
        </dc:description>
    </xsl:template>
    <xsl:template match="ead:scopecontent">
        <dc:description><xsl:value-of select=".//ead:p"/>
        </dc:description>
    </xsl:template>
    <xsl:template match="ead:controlaccess">
        <xsl:apply-templates select="child::*[not(local-name() = 'head')]"/>
    </xsl:template>
    <xsl:template match="ead:subject | ead:persname | ead:genreform | ead:corpname | ead:geogname | ead:occupation">
        <dc:subject><xsl:value-of select="normalize-space(.)"/>
        </dc:subject>
    </xsl:template>
    <xsl:template match="ead:dsc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ead:c">
        <dcterms:hasPart rdf:resource="{$collection_base-uri}{$collection_id}/{generate-id(parent::ead:c)}/{generate-id()}"/>
    </xsl:template>
    <xsl:template name="series">
        <xsl:param name="path">
            <xsl:call-template name="showpath"/>
        </xsl:param>
        <rdf:Description rdf:about="{$collection_base-uri}{$collection_id}/{generate-id(parent::ead:c)}/{generate-id()}">
            <xsl:apply-templates select="ead:did/* | ead:scopecontent | child::ead:c"/>
            <dc:type rdf:resource="http://ldpd.columbia.edu/ldpdterms/archives/level/{@level}"/>
        </rdf:Description>
    </xsl:template>
    <xsl:template match="ead:container"/>
    <xsl:template match="ead:unitdate"/>
    <xsl:template name="showpath">
        <xsl:for-each select="ancestor-or-self::*">
            <xsl:call-template name="print-step"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="print-step">
        <xsl:value-of select="name()"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="1+count(preceding-sibling::*)"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
</xsl:stylesheet>