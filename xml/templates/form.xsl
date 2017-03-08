<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="form">
        <xsl:param name="formular"/>
        <!-- Anzahl Formularelemente ermitteln -->
        <xsl:variable name="anzFE" select="count($formular/descendant::*[1])"/>
        <xsl:choose>
            <!-- wenn groesser 1, rekursiver Aufbau des Formulars -->
            <xsl:when test="$anzFE &gt; 1">
                <xsl:call-template name="formElem">
                    <xsl:with-param name="ende" select="$anzFE"/>
                    <xsl:with-param name="anfang" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <!-- wenn genau 1, keine "unnoetige" Rekursion -->
            <xsl:otherwise>
                <!-- Formularfeld in Variable -->
                <xsl:variable name="formElem" select="$formular/descendant::*[1]"/>
                <!-- erstes (action) und zweites (method) Attribut von <form> ermitteln 
                     hier mit-->
                <form action="{$formular/@*[1]}" method="{$formular/@*[2]}">
                    <p>
                        <label>
                            <xsl:value-of select="concat($formElem/@*[1],': ')"/>
                            <xsl:variable name="id" select="string($formElem/@*[2])"></xsl:variable>
                            <xsl:variable name="type" select="string($formElem/@*[3])"></xsl:variable>
                            <xsl:variable name="name" select="string($formElem/@*[4])"></xsl:variable>
                            <xsl:variable name="place" select="string($formElem/@*[5])"></xsl:variable>
                            <xsl:variable name="autocomplete" select="string($formElem/@*[6])"></xsl:variable>
                            <xsl:variable name="required" select="string($formElem/@*[7])"></xsl:variable>
                            <input size="23" id="{$id}"
                                type="{$type}"
                                name="{$name}"
                                placeholder="{$place}"
                                autocomplete="{$autocomplete}"
                                required="{$required}"/>
                        </label>
                    </p>
                    <p>
                        <button>Anmelden</button>
                        <button id="abmelden">Abmelden</button>
                    </p>
                </form>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formElem">
        <xsl:param name="ende"/>
        <xsl:param name="anfang"/>
        <!-- Moeglichkeit mehrerer Felder zB fuer Kontaktfeld 
             - ueber rekursiven Aufruf+<xsl:if test="$anfang &lt;=$ende"> des Templates formElem
             - dabei werden moegliche uebergebene Array-Param mit dem Parameter $anfang selektiert zB formElem2[$anfang] 
             - Parameter lassen sich mit with-param ueberschreiben, dadurch $zaehlt anfang so lange hoch, bis $ende erreicht -->
        <!--<xsl:call-template name="formElem">
                <xsl:with-param name="anfang" select="$anfang + 1"/>
                <xsl:with-param name="ende" select="$ende"/>
            </xsl:call-template>-->
    </xsl:template>
</xsl:stylesheet>
