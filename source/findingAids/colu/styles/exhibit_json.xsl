<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="urn:isbn:1-931666-22-9" version="1.0">
    <xsl:output encoding="UTF-8" indent="yes" method="text"/>
    <xsl:template match="/">
        <xsl:variable name="quot">"</xsl:variable>
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:text>{
</xsl:text>
        <xsl:text>"items": [
</xsl:text>
        <xsl:for-each select="//ead:c//ead:unitdate">
            <xsl:sort select="."/>
            <xsl:text>{   label: "</xsl:text>
            <xsl:value-of select="translate(translate(normalize-space(parent::ead:unittitle),$quot,$apos), $apos, ' ')"/>
            <xsl:text>",
</xsl:text>
            <xsl:text>   fileNum: "</xsl:text>
            <xsl:for-each select="ancestor::ead:c[@level = 'file']">
                <xsl:value-of select="count(preceding-sibling::ead:c[@level = 'file']) + 1"/>
            </xsl:for-each>
            <xsl:text>",</xsl:text>
            <xsl:text>
                series: "</xsl:text>
            <xsl:value-of select="translate(translate(normalize-space(ancestor::ead:c[@level = 'series']/ead:did/ead:unittitle),$quot,$apos), $apos, ' ')"/>
            <xsl:text>",</xsl:text>
            <xsl:text>
                seriesNum: "</xsl:text>
            <xsl:for-each select="ancestor::ead:c[@level = 'series']">
                <xsl:value-of select="count(preceding-sibling::ead:c[@level = 'series']) + 1"/>
            </xsl:for-each>
            <xsl:text>",</xsl:text>
            <xsl:if test="ancestor::ead:c[@level = 'subseries']">
                <xsl:text>
                subseries: "</xsl:text>
                <xsl:value-of select="translate(translate(normalize-space(ancestor::ead:c[@level = 'subseries']/ead:did/ead:unittitle),$quot,$apos), $apos, ' ')"/>
                <xsl:text>",</xsl:text>
                <xsl:text>
                subseriesNum: "</xsl:text>
                <xsl:for-each select="ancestor::ead:c[@level = 'subseries']">
                    <xsl:value-of select="count(preceding-sibling::ead:c[@level = 'subseries']) + 1"/>
                </xsl:for-each>
                <xsl:text>",</xsl:text>
            </xsl:if>
            <xsl:text>
   type: "</xsl:text>
            <xsl:value-of select="ancestor::ead:c[1]/@level"/>
            <xsl:text>",</xsl:text>
            <xsl:choose><xsl:when test="@normal">
                    <xsl:choose><xsl:when test="contains(@normal, '/')">
                            <xsl:text>
   startDate: "</xsl:text>
                            <xsl:value-of select="substring-before(@normal, '/')"/>
                            <xsl:if test="string-length(substring-before(@normal, '/')) = 4">
                                <xsl:text>-01-01</xsl:text>
                            </xsl:if>
                            <!--
                                <xsl:text>T00:00:01Z</xsl:text>
                            -->
                            <xsl:text>
   endDate: "</xsl:text>
                            <xsl:value-of select="substring-after(@normal, '/')"/>
                            <xsl:if test="string-length(substring-after(@normal, '/')) = 4">
                                <xsl:text>-12-31</xsl:text>
                            </xsl:if>
                          <!--  <xsl:text>T23:59:59Z</xsl:text> -->
                        </xsl:when>
                        <xsl:otherwise><xsl:text>
   startDate: "</xsl:text>
                            <xsl:value-of select="@normal"/>
                            <xsl:if test="string-length(@normal) = 4">
                                <xsl:text>-01-01</xsl:text>
                            </xsl:if>
                       <!--     <xsl:text>T00:00:01Z</xsl:text> -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise><xsl:text>
   startDate: "</xsl:text>
                    <xsl:if test="starts-with(., '1') or starts-with(., '2')">
                        <xsl:value-of select="substring(., 1, 4)"/>
                        <xsl:text>-01-01</xsl:text>
                    <!--    <xsl:text>T00:00:01Z</xsl:text> -->
                    </xsl:if>
                    <xsl:if test="contains(., '-')">
                        <xsl:text>",
endDate: "</xsl:text>
                        <xsl:value-of select="substring(., 6, 5)"/>
                        <xsl:text>-01-01</xsl:text>
                   <!--     <xsl:text>T00:00:01Z</xsl:text> -->
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>"
}</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:text>
</xsl:text>
        </xsl:for-each>
        ]
        }
    </xsl:template>
</xsl:stylesheet>