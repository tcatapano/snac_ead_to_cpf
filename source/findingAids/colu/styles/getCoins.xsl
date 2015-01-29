<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="urn:isbn:1-931666-22-9" version="1.0">
    <xsl:output indent="yes" method="html" encoding="iso-8859-1"/>
    <xsl:template match="/">
        <xsl:text>ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=document&amp;</xsl:text>
        <!-- <xsl:value-of select="normalize-space(//ead:eadheader/ead:eadid/text())"/> -->
        <xsl:for-each select="//ead:eadheader//*[@encodinganalog]">
            <xsl:variable name="aname" select="@encodinganalog"/>
            <xsl:if test="$aname = 'Title'">
                <xsl:text>rft.btitle=</xsl:text>
                <xsl:value-of select="translate(normalize-space(.), ' ', '+')"/>
                <xsl:if test="position() != last()"/>
            </xsl:if>
            <xsl:if test="$aname = 'Contributor'">
                <xsl:text>&amp;rft.aucorp=Rare+Book+and+Manuscripts+Library.+Columbia+University+Libraries</xsl:text>
            </xsl:if>
            <xsl:if test="$aname = 'Date'">
                <xsl:text>&amp;rft.date=</xsl:text>
                <xsl:value-of select="translate(normalize-space(.), ' ', '+')"/>
            </xsl:if>
           <!-- <xsl:value-of select="@encodinganalog"/>=<xsl:value-of select="translate(normalize-space(.), ' ', '+')"/> -->
        </xsl:for-each>
        <!--<xsl:text>&</xsl:text>
        <xsl:for-each select="//ead:archdesc/ead:controlaccess/*[local-name() != 'head']">
            <xsl:text>rft.subject=</xsl:text><xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
                <xsl:text>&</xsl:text>
            </xsl:if>
        </xsl:for-each>
-->
    </xsl:template>
</xsl:stylesheet>