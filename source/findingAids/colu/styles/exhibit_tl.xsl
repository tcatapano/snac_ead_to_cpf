<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ex="http://simile.mit.edu/exhibit" version="1.0">
    <xsl:output method="html"/>
    <xsl:param name="doc"/>
    <xsl:template match="/">
        <html><head><title>Timeline</title>
                <link href="http://simile.mit.edu/babel/translator?reader=exhibit-json&amp;writer=exhibit-jsonp&amp;url=http://appdev.cul.columbia.edu:8080/exist/rest/db/ead/nnc-rb/getExhibitDSC.xquery?doc={$doc}" type="application/jsonp" rel="exhibit/data"/>
                <script src="http://static.simile.mit.edu/exhibit/api-2.0/exhibit-api.js" type="text/javascript"/>
                <script src="http://static.simile.mit.edu/exhibit/extensions-2.0/time/time-extension.js" type="text/javascript"/>
                <style><xsl:text>body {
                    margin: 1in;
                    }
                    table.nobelist {
                    border:     1px solid #ddd;
                    padding:    0.5em;
                    }
                    div.name {
                    font-weight: bold;
                    font-size:   120%;
                    }
                    .discipline {
                    }
                    .year {
                    font-style:  italic;
                    }
                    .relationship {
                    color:  #888;
                    }
                    .co-winners {
                    }</xsl:text>
                </style>
            </head>
            <body><h1>Timeline</h1>
                <table width="100%">
                    <tr valign="top">
                        <td width="20%">
                            <div><em>Search</em>
                            </div>
                            <div ex:role="facet" ex:facetClass="TextSearch"/>
                        </td>
                        <td width="40%">
                            <div ex:role="facet" ex:expression=".series" ex:facetLabel="Series"/>
                        </td>
                        <td width="40%">
                            <div ex:role="facet" ex:expression=".subseries" ex:facetLabel="Subseries"/>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="3" ex:role="viewPanel">
                            <table ex:role="lens" class="nobelist">
                                <tr><td><div ex:content=".label" class="name"/>
                                        <div><span ex:content=".type" class="discipline"/>
                                            <span ex:content=".series" class="discipline"/>
                                            <span ex:content=".subseries" class="discipline"/>
                                            <span ex:content=".startDate" class="year"/>
                                            <span ex:content=".endDate" class="year"/>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <!--         <div ex:role="exhibit-view"
                                ex:viewClass="Exhibit.TabularView"
                                ex:columns=" .label,.type, .series, .seriesNum, .subseries, .subseriesNum,.startDate, .endDate"
                                ex:columnLabels="Title, Type, Series, Series Number, Subseries, Subseries Number, Start Date, End Date"
                                ex:columnFormats="list, list, list, list, list, list, list, list"
                                ex:sortColumn="4"
                                ex:sortAscending="true">
                                </div>
                            -->
                            <div ex:role="view" ex:viewClass="Timeline" ex:start=".startDate" ex:end=".endDate" ex:colorKey=".type" ex:topBandUnit="decade" ex:bottomBandUnit="century" ex:bottomBandPixelsPerUnit="400" ex:topBandPixelsPerUnit="150" ex:timelineHeight="400" ex:topBandHeight="75"/>
                            <!--        <div ex:role="view"
                                ex:orders=".seriesNum, .subseriesNum, .fileNum, .startDate, .label, .type"
                                ex:possibleOrders=".label, .series, .subseries, .startDate, .endDate, .type">
                                </div>
                            -->
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>