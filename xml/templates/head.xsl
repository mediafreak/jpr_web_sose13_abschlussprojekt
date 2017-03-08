<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="head">
        <xsl:param name="seite"/>
        <xsl:param name="seiteLC"/>
        <head>
            <title>Tin Pan Alley Steelband - <xsl:value-of select="$seite"/></title>
            <!-- Verlinkung/Import zu verwendeten externen CSS-Dateien -->
            <link rel="stylesheet" href="../../css/stylesheets.css" type="text/css" media="screen" title="stylesheets"/>
            <!-- Verlinkung zu typography-stylesheets, die in xml-Datei identisch -->
            <link rel="stylesheet" href="../../css/xml/xml_tpa_typography.css" type="text/css" media="screen" title="stylesheets"/>
            <!-- Verlinkung dynamnisch durch Parameter/Variable -->
            <link rel="stylesheet" href="{concat('../../css/xml/xml_tpa_',$seiteLC,'.css')}" type="text/css" media="screen" title="stylesheets"/>
            <!-- Verlinkung/Import zu verwendeten externen JS-Dateien -->
            <script type="text/javascript" src="../../js/jquery-1.8.2.min.js"></script>
            <script type="text/javascript" src="../../js/jquery.cookie.js"></script>
            <script type="text/javascript" src="../../js/navigation.js"></script>
        </head>
    </xsl:template>
</xsl:stylesheet>
