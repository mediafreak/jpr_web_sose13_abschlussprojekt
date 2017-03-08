<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <!-- importiert Templates aus externen xsl-Dat, muss direkt hinter xsl:stylesheet-Deklaration -->
  <xsl:import href="head.xsl"/>
  <xsl:import href="headerNav.xsl"/>
  <xsl:import href="form.xsl" />
  <xsl:import href="umbruch.xsl" />
  
  <!-- Output method="html":              voreingestellt, 
              omit-xml-declaration="yes": nur fuer method="xml", unterdrueckt XML-Deklaration 
              doctype-system:             legt den systemimmanenten Bezeichner an, der in der 
                                          <!DOCTYPE>-Deklaration verwendet werden soll (nicht sichtbar)
              doctype-public:             legt den oeffentlichen Bezeichner an, der in der 
                                          <!DOCTYPE>-Deklaration verwendet werden soll (nicht sichtbar)
              indent="no":                verhindert ueberfluessige Leerzeichen im Quellcode (Performance) -->
  <xsl:output 
    method="html"
    version="5.0"
    encoding="utf-8"
    doctype-public = "HTML" 
    doctype-system = "about:legacy-compat" 
    indent="no"
  />
    
  <!-- <xsl:template>-Element erzeugt Vorlagen; 
       name-Attribut definiert einen eindeutigen Namen fuer das Template, der spaeter weiter verwendet werden kann. -->
  <xsl:template name="html">
    <xsl:param name="seite"/>
    <xsl:param name="seiteLC"/>
    <xsl:param name="id"/>
    
    <html>
      <!-- ruft importiertes Template 'head' auf und uebergibt die globale Variablen 'seite' und 'seiteLC' als Parameter -->
      <xsl:call-template name="head">
        <xsl:with-param name="seite" select="$seite"/>
        <xsl:with-param name="seiteLC" select="$seiteLC"/>
      </xsl:call-template>

      <body>
        <!-- um webseite im browser zu zentrieren -->
        <div id="doc">
          <!-- ruft importiertes Template 'header' auf und uebergibt die globale Variable 'id' als Parameter -->
          <xsl:call-template name="headerNav">
            <xsl:with-param name="id" select="$id" />
          </xsl:call-template>
          
          <article id="{string($seiteLC)}">
            <!-- Wert in Variable speichern (Performance):
             => XSLT-Prozessor muss Wert nur einmal ermitteln, 
             => Werte in Variablen von  meisten XSLT-Prozessoren gecached. -->
            <!-- descendant::*[1] statt 'aside' verwendet, um zu zeigen, dass es auch ohne genauem Knoten-Namen geht 
                 (descendant:: => waehlt das Tag mindestens eine Ebene tiefer aus. 
                 *[not(descendant::s)] => verneinung geht auch => alle Elemente die als Kind oder Kindeskind kein <s>-Tag haben)
                 Falls aber andere Knoten wie bilder u.a. hinzukommen, kann es damit kritisch werden, wenn nicht genau bekannt ist, an welcher
                 Position im Eltern-Knoten sich die Kinderelemente befinden (zB wenn Kollege nicht in Schema- oder XML-Datei schaut)
                 Vorteil der Positionsnummer ist, dass ich meine Knoten jederzeit umbenennen kann, ohne in die xsl-Datei zu muessen -->
            <xsl:variable name="aside" select="*/descendant::*[1]" />
            <aside>
              <h4><xsl:value-of select="$aside/@headline"/></h4>
              <!-- Text auf Umbrueche ueberpruefen und diese je nach Prozessor in erforderlichen <br /> umwandeln -->
              <p>
                <xsl:call-template name="umbrueche">
                  <!-- text() liest nur Text, keine enthaltenen Kinderknoten -->
                  <xsl:with-param name="text" select="$aside/descendant::*/text()" />
                </xsl:call-template>
              </p>  
              <xsl:if test="boolean($aside/descendant::*[2])">
                <xsl:variable name="formular" select="$aside/descendant::*[2]"></xsl:variable>
                <xsl:call-template name="form">
                  <xsl:with-param name="formular" select="$formular"/>
                </xsl:call-template>
              </xsl:if>
            </aside>
            
            <!-- XPATH-Achse following-sibling::* alle nachfolgenden Geschwisterknoten von 'aside' (gleiche Ebene) -->
            <xsl:variable name="xpathFS" select="/*/descendant::*[1]/following-sibling::*" /> <!-- var Performance (s. aside.xsl) -->
            <xsl:choose>
              <xsl:when test="$id=5"><section><xsl:apply-templates select="$xpathFS"/></section></xsl:when>
              <xsl:otherwise><xsl:apply-templates select="$xpathFS"/></xsl:otherwise>
            </xsl:choose>
            
            <!-- oder Weg ueber zwei if-Abfragen, Prozessor muss dann aber auch zweimal einen Test durchlaufen
                 <xsl:if test="$id=5">
                    <section><xsl:apply-templates select="$xpathFS"/></section>
                  </xsl:if>
                  <xsl:if test="$id!=5">
                    <xsl:apply-templates select="$xpathFS"/>
                  </xsl:if> -->
          </article>
          <!-- ruft importiertes Template 'footer' auf und uebergibt die globale Variable 'seite' als Parameter -->
          <footer id="footer"><a href="../../html/impressum.html" title="Impressum">Impressum</a> | <a href="http://www.xmlvalidation.com/?L=2" title="XML-Validator">XML-Validator</a>
            <!-- validome.org derzeit nicht erreichbar - schade!!! -->
            <!-- <a href="{concat('http://www.validome.org/xml/validate/?lang=ge&amp;viewSourceCode=1&amp;url=http://www.mediafreak.info/studium/xml/',$seiteLC,'/',$seiteLC,'.xml')}">
              www.validome.org – XML-Validator</a> -->
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
