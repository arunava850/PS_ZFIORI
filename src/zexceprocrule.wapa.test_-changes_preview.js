var version=sap.ui.version.split(".");if(parseInt(version[0],10)<=1&&parseInt(version[1],10)<78){sap.ui.getCore().loadLibraries(["sap/ui/fl"]);sap.ui.require(["sap/ui/fl/FakeLrepConnector"],function(e){jQuery.extend(e.prototype,{create:function(e){return+
 Promise.resolve()},stringToAscii:function(e){if(!e||e.length===0){return""}var n="";for(var t=0;t<e.length;t++){n+=e.charCodeAt(t)+","}if(n!==null&&n.length>0&&n.charAt(n.length-1)===","){n=n.substring(0,n.length-1)}return n},loadChanges:function(){var +
n={changes:[],settings:{isKeyUser:true,isAtoAvailable:false,isProductiveSystem:false}};var t=[];var r="/sap-ui-cachebuster-info.json";return new Promise(function(a,o){$.ajax({url:r,type:"GET",cache:false}).then(function(e){var n=Object.keys(e).filter(fun+
ction(e){return e.endsWith(".change")});$.each(n,function(e,n){if(n.indexOf("changes")===0){t.push($.ajax({url:"/"+n,type:"GET",cache:false}).then(function(e){return JSON.parse(e)}))}})}).always(function(){return Promise.all(t).then(function(r){return ne+
w Promise(function(e,n){if(r.length===0){$.ajax({url:"/changes/",type:"GET",cache:false}).then(function(n){var r=/(\/changes\/[^"]*\.[a-zA-Z]*)/g;var a=r.exec(n);while(a!==null){t.push($.ajax({url:a[1],type:"GET",cache:false}).then(function(e){return JSO+
N.parse(e)}));a=r.exec(n)}e(Promise.all(t))}).fail(function(n){e(r)})}else{e(r)}}).then(function(t){var r=[],o=[];t.forEach(function(n){var t=n.changeType;if(t==="addXML"||t==="codeExt"){var a=t==="addXML"?n.content.fragmentPath:t==="codeExt"?n.content.c+
odeRef:"";var c=a.match(/webapp(.*)/);var s="/"+c[0];r.push($.ajax({url:s,type:"GET",cache:false}).then(function(r){if(t==="addXML"){n.content.fragment=e.prototype.stringToAscii(r.documentElement.outerHTML);n.content.selectedFragmentContent=r.documentEle+
ment.outerHTML}else if(t==="codeExt"){n.content.code=e.prototype.stringToAscii(r);n.content.extensionControllerContent=r}return n}))}else{o.push(n)}});if(r.length>0){return Promise.all(r).then(function(e){e.forEach(function(e){o.push(e)});o.sort(function+
(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=o;var t={changes:n,componentClassName:"com.public.storage.excessproceedrule"};a(t)})}else{o.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=o;var c={change+
s:n,componentClassName:"com.public.storage.excessproceedrule"};a(c)}})})})})}});e.enableFakeConnector()})}                                                                                                                                                     
//# sourceMappingURL=changes_preview.js.map                                                                                                                                                                                                                    