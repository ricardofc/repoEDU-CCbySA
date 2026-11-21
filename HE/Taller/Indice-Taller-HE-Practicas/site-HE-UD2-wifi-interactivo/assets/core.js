/* Utilidades compartidas: tema, navegación de abas, copia, disector 22000/5500, tshark e quiz */
(function(global){
  "use strict";

  function safeStorageGet(k){ try{ return localStorage.getItem(k); }catch(_){ return null; } }
  function safeStorageSet(k,v){ try{ localStorage.setItem(k,v); }catch(_){} }

  function initTheme(){
    var root=document.documentElement;
    var saved=safeStorageGet("wifi_theme");
    if(saved==="dark"||saved==="light") root.setAttribute("data-theme",saved);
    var tb=document.getElementById("themeBtn");
    if(!tb) return;
    function cur(){
      var a=root.getAttribute("data-theme");
      if(a) return a;
      return matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light";
    }
    tb.addEventListener("click",function(){
      var next=cur()==="dark"?"light":"dark";
      root.setAttribute("data-theme",next);
      safeStorageSet("wifi_theme",next);
    });
  }

  function initViewTabs(defaultView){
    var views=document.querySelectorAll("div[data-view]");
    var navLinks=document.querySelectorAll("#nav a[data-view]");
    if(!views.length||!navLinks.length) return;
    var valid={};
    views.forEach(function(v){ valid[v.getAttribute("data-view")]=1; });
    function showView(h){
      if(!valid[h]) h=defaultView;
      views.forEach(function(v){ v.hidden = v.getAttribute("data-view")!==h; });
      navLinks.forEach(function(a){ a.classList.toggle("active", a.getAttribute("data-view")===h); });
      try{ window.scrollTo(0,0); }catch(_){}
    }
    function handleNav(h){
      try{
        if(window.history && history.replaceState) history.replaceState(null,"","#"+h);
        else location.hash=h;
      }catch(_){}
      showView(h);
    }
    navLinks.forEach(function(a){
      a.addEventListener("click",function(e){
        e.preventDefault();
        handleNav(a.getAttribute("data-view"));
      });
    });
    document.addEventListener("click",function(e){
      var t=e.target.closest && e.target.closest("a[data-jump]");
      if(t){
        e.preventDefault();
        handleNav(t.getAttribute("data-jump"));
      }
    });
    window.addEventListener("hashchange",function(){ showView((location.hash||"").replace("#","")); });
    showView((location.hash||"").replace("#",""));
  }

  function copyText(txt, btn){
    function ok(){
      if(!btn) return;
      var old=btn.textContent;
      btn.textContent="Copiado ✓";
      setTimeout(function(){ btn.textContent=old; },1400);
    }
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(txt).then(ok, fallback);
    }else{ fallback(); }
    function fallback(){
      var ta=document.createElement("textarea");
      ta.value=txt; ta.style.position="fixed"; ta.style.opacity="0";
      document.body.appendChild(ta); ta.select();
      try{ document.execCommand("copy"); ok(); }catch(_){}
      document.body.removeChild(ta);
    }
  }

  function initCopyButtons(){
    document.addEventListener("click",function(e){
      var b=e.target.closest && e.target.closest(".copy-btn");
      if(!b) return;
      var pre=b.parentElement;
      var clone=pre.cloneNode(true);
      var btnIn=clone.querySelector(".copy-btn");
      if(btnIn) btnIn.remove();
      copyText(clone.textContent.trim(), b);
    });
  }

  function strToHex(str){
    var out="";
    for(var i=0;i<str.length;i++){
      var c=str.charCodeAt(i);
      if(c<128) out += c.toString(16).padStart(2,"0");
      else {
        var enc=encodeURIComponent(str[i]).replace(/%/g,"").toLowerCase();
        out += enc;
      }
    }
    return out;
  }

  function hexToStr(hex){
    var clean=hex.replace(/[^0-9a-fA-F]/g,"");
    var bytes="";
    for(var i=0;i<clean.length;i+=2){
      bytes += "%" + clean.substr(i,2);
    }
    try{ return decodeURIComponent(bytes); }catch(_){ return "(bytes non UTF-8)"; }
  }

  function renderDissector22000(el){
    if(!el) return;
    var datasets={
      wpa02:{
        label:"WPA*02 (EAPOL / combinado)",
        sep:"*",
        note:"Identifica material EAPOL do 4-way handshake (ou combinación PMKID+EAPOL). O modo 22000 de hashcat unifica os antigos modos 2500 e 16800.",
        tokens:[
          {v:"WPA",k:"1. Tipo",d:"Cabeceira do formato unificado de hashcat para redes WPA/WPA2/WPA3."},
          {v:"02",k:"2. Versión / Subtipo",d:"02 indica formato EAPOL (4-way handshake). Para un PMKID puro verías 01."},
          {v:"60d9443cc2379bd16ff29371e8aeea87",k:"3. PMKID / MIC (16 bytes)",d:"Se é captura combinada (ep+++) contén o PMKID = HMAC-SHA1-128(PMK, \"PMK Name\" || MAC_AP || MAC_STA); en handshake puro é o MIC do Message 2."},
          {v:"a6c49421b094",k:"4. MAC_AP (BSSID)",d:"Enderezo MAC do Punto de Acceso sen dous puntos."},
          {v:"2e2e65aef8ed",k:"5. MAC_STA (Cliente)",d:"Enderezo MAC da estación/cliente que participou no intercambio."},
          {v:"454d50524553412d58595a",k:"6. ESSID en hexadecimal",d:"Nome da rede Wi-Fi en hex: 454d50524553412d58595a = \"EMPRESA-XYZ\". Entra no cálculo PBKDF2(PSK, SSID, 4096)."},
          {v:"209c3cccbc531952b5351c647288ac30ca493f7c3aba497c6fb5de9642955dbb",k:"7. ANonce (32 bytes)",d:"Número aleatorio xerado polo AP no Message 1/4 para derivar a PTK."},
          {v:"0103007502010a...0fac020000",k:"8. Datos EAPOL",d:"Contido hexadecimal completo da trama EAPOL-Key (inclúe SNonce e elementos RSN)."},
          {v:"10",k:"9. Tipo de mensaxe",d:"Identifica que mensaxes se capturaron (p.ex. 10 = combinación PMKID + EAPOL para máxima compatibilidade)."}
        ]
      },
      wpa01:{
        label:"WPA*01 (PMKID puro)",
        sep:"*",
        note:"Unha captura só é válida como evidencia de PMKID na Práctica 1.4 se hcxpcapngtool exporta polo menos unha liña que comece por WPA*01*.",
        tokens:[
          {v:"WPA",k:"1. Tipo",d:"Formato unificado de hashcat modo 22000."},
          {v:"01",k:"2. Subtipo PMKID",d:"01 indica PMKID puro (sen depender dun handshake completo de 4 mensaxes)."},
          {v:"60d9443cc2379bd16ff29371e8aeea87",k:"3. PMKID (16 bytes)",d:"HMAC-SHA1-128(PMK, \"PMK Name\" || MAC_AP || MAC_STA). Permítelle a hashcat verificar candidatos offline."},
          {v:"a6c49421b094",k:"4. MAC_AP (BSSID)",d:"MAC do punto de acceso obxectivo."},
          {v:"2e2e65aef8ed",k:"5. MAC_STA (atacante/cliente)",d:"MAC da estación que recibiu o EAPOL M1 co PMKID."},
          {v:"454d50524553412d58595a",k:"6. ESSID en hex",d:"\"EMPRESA-XYZ\" en hexadecimal. Necesario como sal en PBKDF2."},
          {v:"",k:"7–9. Campos baleiros",d:"En WPA*01 non fan falta ANonce nin trama EAPOL completa: remata con ***."}
        ]
      }
    };
    var mode="wpa02", sel=0;
    function draw(){
      var ds=datasets[mode];
      var html='<div class="dis-tabs">';
      Object.keys(datasets).forEach(function(k){
        html+='<button class="dis-tab" data-m="'+k+'" data-on="'+(k===mode?1:0)+'">'+datasets[k].label+'</button>';
      });
      html+='</div><div class="hash-tokens">';
      ds.tokens.forEach(function(t,i){
        if(i>0) html+='<span class="hsep">'+ds.sep+'</span>';
        var showV=t.v===""?"(baleiro)":t.v;
        html+='<button class="htok" type="button" data-i="'+i+'" data-on="'+(i===sel?1:0)+'">'+showV+'</button>';
      });
      html+='</div>';
      var cur=ds.tokens[sel]||ds.tokens[0];
      html+='<div class="dis-info"><div class="dk">'+cur.k+'</div><p>'+cur.d+'</p><p style="margin-top:6px;font-size:12px"><b>Nota:</b> '+ds.note+'</p></div>';
      html+='<div class="hex-conv"><span>Conversor ESSID ↔ Hex:</span>'+
        '<input type="text" id="essidAscii" value="EMPRESA-XYZ" aria-label="ESSID ASCII" placeholder="SSID">'+
        '<span>⇄</span>'+
        '<input type="text" id="essidHex" value="454d50524553412d58595a" aria-label="ESSID Hex" placeholder="Hex"></div>';
      el.innerHTML=html;

      el.querySelectorAll(".dis-tab").forEach(function(b){
        b.addEventListener("click",function(){ mode=b.getAttribute("data-m"); sel=0; draw(); });
      });
      el.querySelectorAll(".htok").forEach(function(b){
        b.addEventListener("click",function(){ sel=Number(b.getAttribute("data-i")); draw(); });
      });
      var ascii=el.querySelector("#essidAscii"), hex=el.querySelector("#essidHex");
      ascii.addEventListener("input",function(){ hex.value=strToHex(ascii.value); });
      hex.addEventListener("input",function(){ ascii.value=hexToStr(hex.value); });
    }
    draw();
  }

  function renderDissector5500(el){
    if(!el) return;
    var tokens=[
      {v:"ana",k:"1. Username (EAP Identity)",d:"Capturado en texto claro durante a fase EAP Identity antes do túnel TLS. hostapd-wpe rexístrao directamente."},
      {v:"",k:"2. Dominio (baleiro)",d:"Campo herdado do formato NTLM completo de Windows; en PEAP/MSCHAPv2 simple vai baleiro."},
      {v:"",k:"3. Host (baleiro)",d:"Non usado en MSCHAPv2 sobre EAP."},
      {v:"",k:"4. LMResponse (baleiro)",d:"Ausente en NetNTLMv1 puro capturado por hostapd-wpe."},
      {v:"de89e682929a6bc170ed4233e8867e24ec0f429da91772b5",k:"5. NTResponse (24 bytes · 48 hex)",d:"Calculado polo cliente: DES sobre MD4(UTF-16LE(contrasinal)) usando o Challenge. É moito máis rápido de crackear que PBKDF2 (~1.800 MH/s vs ~4.500 H/s)."},
      {v:"e70a88fc72b2f83f",k:"6. Challenge (8 bytes · 16 hex)",d:"Desafío aleatorio xerado polo servidor EAP (o Evil Twin neste caso) e enviado ao cliente."}
    ];
    var sel=4;
    function draw(){
      var html='<div class="hash-tokens">';
      tokens.forEach(function(t,i){
        if(i>0) html+='<span class="hsep">:</span>';
        html+='<button class="htok" type="button" data-i="'+i+'" data-on="'+(i===sel?1:0)+'">'+(t.v===""?"∅":t.v)+'</button>';
      });
      html+='</div>';
      var cur=tokens[sel];
      html+='<div class="dis-info"><div class="dk">'+cur.k+'</div><p>'+cur.d+'</p></div>';
      el.innerHTML=html;
      el.querySelectorAll(".htok").forEach(function(b){
        b.addEventListener("click",function(){ sel=Number(b.getAttribute("data-i")); draw(); });
      });
    }
    draw();
  }

  function renderTshark(el, views){
    if(!el||!views||!views.length) return;
    var cur=0;
    function draw(){
      var v=views[cur];
      var html='<div class="tshark-filters">';
      views.forEach(function(x,i){
        html+='<button class="tf-btn" data-i="'+i+'" data-on="'+(i===cur?1:0)+'">'+x.label+'</button>';
      });
      html+='</div><div class="tshark-cmd"><span>$ '+v.cmd+'</span></div>';
      html+='<div style="overflow-x:auto"><table class="tshark-table"><thead><tr>';
      v.cols.forEach(function(c){ html+='<th>'+c+'</th>'; });
      html+='</tr></thead><tbody>';
      v.rows.forEach(function(r){
        html+='<tr class="'+(r.hl?'hl':'')+'">';
        r.cells.forEach(function(c){ html+='<td>'+c+'</td>'; });
        html+='</tr>';
      });
      html+='</tbody></table></div><div class="tshark-note">'+v.note+'</div>';
      el.innerHTML=html;
      el.querySelectorAll(".tf-btn").forEach(function(b){
        b.addEventListener("click",function(){ cur=Number(b.getAttribute("data-i")); draw(); });
      });
    }
    draw();
  }

  function renderQuiz(el, items){
    if(!el||!items||!items.length) return;
    var answered={};
    function draw(){
      var okCount=0, tot=0;
      Object.keys(answered).forEach(function(k){ tot++; if(answered[k].ok) okCount++; });
      var html='<div class="quiz">';
      items.forEach(function(it,qi){
        var st=answered[qi];
        html+='<div class="qitem"><h4>'+(qi+1)+'. '+it.q+'</h4><div class="qopts">';
        it.opts.forEach(function(op,oi){
          var cls="qopt";
          if(st){
            if(oi===it.ans) cls+=" ok";
            else if(st.choice===oi && !st.ok) cls+=" ko";
          }
          html+='<button class="'+cls+'" type="button" data-q="'+qi+'" data-o="'+oi+'">'+op+'</button>';
        });
        html+='</div>';
        if(st){
          html+='<div class="qfb show '+(st.ok?'ok':'ko')+'"><b>'+(st.ok?'✓ Correcto. ':'✗ Coidado: ')+'</b>'+it.exp+'</div>';
        }
        html+='</div>';
      });
      html+='</div><div class="qscore">Respondidas: <b>'+tot+'</b> / '+items.length+' · Aciertos: <b>'+okCount+'</b></div>';
      el.innerHTML=html;
      el.querySelectorAll(".qopt").forEach(function(b){
        b.addEventListener("click",function(){
          var qi=Number(b.getAttribute("data-q")), oi=Number(b.getAttribute("data-o"));
          answered[qi]={choice:oi, ok:oi===items[qi].ans};
          draw();
        });
      });
    }
    draw();
  }

  global.WifiSite={
    initTheme:initTheme,
    initViewTabs:initViewTabs,
    initCopyButtons:initCopyButtons,
    copyText:copyText,
    strToHex:strToHex,
    hexToStr:hexToStr,
    renderDissector22000:renderDissector22000,
    renderDissector5500:renderDissector5500,
    renderTshark:renderTshark,
    renderQuiz:renderQuiz
  };
})(window);
