<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="headerNav">
        <xsl:param name="id" />
        <!-- handelt es sich um einfache true|false Ueberpruefung, sollte statt einer Ueberpruefung des Strings 
             eine boolsche Funktion verwenden -->
        <xsl:variable name="isActiveS" select="boolean($id = '5')"/>
        <xsl:variable name="isActiveG" select="boolean($id = '4')"/>
        <xsl:variable name="isActiveT" select="boolean($id = '3')"/>
        <!-- im Header befindet sich 'Logo', 'Websiteueberschrift' und Naviagtion -->
        <header id="header">
            <a href="../../index.html" accesskey="0" title="[Alt+0] Home">
                <img src="../../img/tpa_logo.png" title="Tin Pan Alley Logo" alt="zwei rote faesser mit Logo der Tin Pan Alley Steelband"/>
            </a>
            <h1>Tin Pan Alley <strong>Steelband</strong></h1>
            <h2>Karibisch, exotisch, aussergewöhnlich</h2>
            <!-- Aufbau der Navigation ueber ungeordnete Liste, Unterteilung in top-nav und main-nav -->
            <nav id="top-nav">
                <ul>
                    <li><a href="#" title="Mitgliederbereich">Mitgliederbereich</a></li>
                    <li><a href="#" title="Kontakt">Kontakt</a></li>
                    <li>
                        <!-- Zuweisung der css-Klasse zu, wenn Link active
                             in diesem Falle Klasse und nicht id, weil es bei Termine/Galerie in der Unternav aktive Punkte gibt,
                             die gemeinsam mit dem "Eltern"-Menuepunkt aktiv sind-->
                        <xsl:if test="$isActiveS = true()">
                            <xsl:attribute name="class"><xsl:text>active</xsl:text></xsl:attribute>
                        </xsl:if>
                        <a href="../sitemap/sitemap.xml" title="Sitemap DTD &lt;xsl:import&gt;">Sitemap DTD &lt;xsl:import&gt;</a>
                    </li>
                    <li><a href="../../html/accesskeySprung.html"  title="Accesskey oder Sprungmarken">Accesskey/Sprungmarken</a></li>
                </ul>
            </nav>

            <nav id="main-nav">
                <ul>
                    <li><a href="../../index.html" accesskey="0" title="[Alt+0] Home">Home</a></li>
                    <li><a href="../../html/band.html" title="Die Band" accesskey="b">Die Band</a></li>
                    <li><a href="../../html/musik.html" title="Die Musik" accesskey="m">Die Musik</a>
                        <!-- untergeordnete Navigation fuer Untermenuepunkte -->
                        <ul>
                            <li><a href="../../html/musik.html" title="Steelpans/-drums" accesskey="s">Steelpans/-drums</a></li>
                            <li><a href="../../html/repertoire.html" title="Repertoire" accesskey="r">Repertoire</a></li>
                            <li><a href="#" title="CD bestelen">CD bestellen</a></li>
                            <li><a href="#" title="Links">Links</a></li>
                        </ul>
                    </li>
                    <li>
                        <xsl:if test="$isActiveT = true()">
                            <xsl:attribute name="class"><xsl:text>active</xsl:text></xsl:attribute>
                        </xsl:if>
                        <a href="../termine/termine.xml" id="T" title="Termine XSD" accesskey="t">Termine XSD</a>
                        <ul id="xmlNavT"/>
                    </li>
                    <li><a href="#" title="Buchung" accesskey="b">Buchung</a></li>
                    <li><a href="#" title="Presse" accesskey="p">Presse</a></li>
                    <li>
                        <xsl:if test="$isActiveG = true()">
                            <xsl:attribute name="class"><xsl:text>active</xsl:text></xsl:attribute>
                        </xsl:if>
                        <a href="../galerie/galerie.xml" id="G" title="Galerie" accesskey="g">Galerie</a>
                        <ul id="xmlNavG"/>
                    </li>
                </ul>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>
