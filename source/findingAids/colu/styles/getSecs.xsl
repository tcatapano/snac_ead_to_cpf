<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ead="urn:isbn:1-931666-22-9" version="1.0">
    <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="template"/>
    <xsl:template match="/">
        <xsl:apply-templates select="ead:ead/ead:archdesc/ead:dsc"/>
    </xsl:template>
    <xsl:template match="ead:dsc">
        <xsl:apply-templates select="child::ead:c"/>
    </xsl:template>
    <xsl:template match="ead:c">
        <ead:c level="{./@level}">
            <xsl:apply-templates select="child::ead:did"/>
            <xsl:choose><xsl:when test="parent::ead:dsc">
                    <xsl:apply-templates select="child::ead:c[@level != 'file']"/>
                </xsl:when>
                <xsl:when test="parent::ead:dsc[parent::ead:dsc]">
                    <xsl:apply-templates select="child::ead:c[@level != 'file']"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </ead:c>
    </xsl:template>
    <xsl:template match="ead:did">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>