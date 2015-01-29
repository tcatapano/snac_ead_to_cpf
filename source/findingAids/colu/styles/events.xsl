<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="urn:isbn:1-931666-22-9" version="1.0">
    <xsl:template match="/">
        <xsl:for-each select="//ead:c//ead:unitdate">
            <xsl:sort select="."/>
            <xsl:element name="event">
                <xsl:attribute name="title">
                    <xsl:for-each select="ancestor::ead:c">
                        <xsl:value-of select="child::ead:did/ead:unittitle"/>
                        <xsl:if test="position() != last()">
                            <xsl:text>&#160;&gt;&#160;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                        <!--<xsl:value-of select="normalize-space(parent::ead:unittitle)"/>-->
                </xsl:attribute>
                <xsl:choose><xsl:when test="@normal">
                        <xsl:choose><xsl:when test="contains(@normal, '/')">
                                <xsl:attribute name="durationEvent">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="start">
                                    <xsl:value-of select="substring-before(@normal, '/')"/>
                                    <xsl:if test="string-length(substring-before(@normal, '/')) = 4">
                                        <xsl:text>-01-01</xsl:text>
                                    </xsl:if>
                                    <xsl:text>T00:00:01Z</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="end">
                                    <xsl:value-of select="substring-after(@normal, '/')"/>
                                    <xsl:if test="string-length(substring-after(@normal, '/')) = 4">
                                        <xsl:text>-12-31</xsl:text>
                                    </xsl:if>
                                    <xsl:text>T23:59:59Z</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise><xsl:attribute name="start">
                                    <xsl:value-of select="@normal"/>
                                    <xsl:if test="string-length(@normal) = 4">
                                        <xsl:text>-01-01</xsl:text>
                                    </xsl:if>
                                    <xsl:text>T00:00:01Z</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise><xsl:attribute name="start">
                            <xsl:if test="starts-with(., '1')">
                                <xsl:value-of select="substring(., 1, 4)"/>
                                <xsl:text>-01-01</xsl:text>
                                <xsl:text>T00:00:01Z</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>